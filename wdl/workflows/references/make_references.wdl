version 1.0


import "../../subworkflows/build_bowtie_index.wdl" as bowtie
import "../../subworkflows/build_bwa_index.wdl" as bwa
import "../../subworkflows/build_fasta_index.wdl" as fai
import "../../subworkflows/build_mappable_only_bed.wdl" as mappable
import "../../subworkflows/get_center_sites.wdl" as center
import "../../subworkflows/get_chrombuckets.wdl" as chr_buckets
import "../../subworkflows/get_chrom_info.wdl" as chr_info
import "../../subworkflows/get_chrom_sizes.wdl" as chr_sizes
import "../../structs/sizes.wdl"

workflow make_references {
    input {
        BowtieIndex? bowtie_index
        BwaIndex? bwa_index
        File? center_sites
        File? chrom_buckets
        File? chrom_info
        File? chrom_sizes
        File? mappable_regions
        File reference_fasta
        Int mappability_kmer_length
        ReferenceMachineSizes machine_sizes = read_json("wdl/default_reference_machine_sizes.json")
    }

    Machines compute = read_json("wdl/runtimes.json")
    String genome_name = basename(reference_fasta, ".fa")
    
    if (!defined(bwa_index)) {
        call bwa.build_bwa_index {
            input:
                fasta=reference_fasta,
                resources=compute.runtimes[machine_sizes.bwa],
        }
    }

    BwaIndex bwa_index_output = select_first([bwa_index, build_bwa_index.bwa_index])

    call fai.build_fasta_index {
        input:
            fasta=reference_fasta,
            resources=compute.runtimes[machine_sizes.fai],
    }

    if (!defined(bowtie_index)) {
        call bowtie.build_bowtie_index {
            input:
                fasta=reference_fasta,
                resources=compute.runtimes[machine_sizes.bowtie]
        }
    }

    BowtieIndex bowtie_index_output = select_first([bowtie_index, build_bowtie_index.bowtie_index])

    if (!defined(mappable_regions)) {
        call mappable.build_mappable_only_bed {
            input:
                bowtie_index=bowtie_index_output,
                kmer_length=mappability_kmer_length,
                reference_genome=reference_fasta,
                resources=compute.runtimes[machine_sizes.mappable],
        }
    }

    File mappable_regions_output = select_first([mappable_regions, build_mappable_only_bed.mappable_regions])

    if (!defined(chrom_buckets)) {
        call chr_buckets.get_chrombuckets {
            input:
                fai=select_first([build_fasta_index.indexed_fasta.fai]),
                genome_name=genome_name,
                resources=compute.runtimes[machine_sizes.chr_buckets],
        }
    }

    File chrom_buckets_output = select_first([chrom_buckets, get_chrombuckets.chrombuckets])

    if (!defined(chrom_sizes)) {
        call chr_sizes.get_chrom_sizes {
            input:
                fai=select_first([build_fasta_index.indexed_fasta.fai]),
                resources=compute.runtimes[machine_sizes.chr_sizes],
        }
    }

    File chrom_sizes_output = select_first([chrom_sizes, get_chrom_sizes.chrom_sizes])

    if (!defined(chrom_info)) {
        call chr_info.get_chrom_info {
            input:
                chrom_sizes=chrom_sizes_output,
                resources=compute.runtimes[machine_sizes.chr_info],
        }
    }

    File chrom_info_output = select_first([chrom_info, get_chrom_info.chrom_info])

    if (!defined(center_sites)) {
        call center.get_center_sites {
            input:
                chrom_sizes=chrom_sizes_output,
                mappable_regions=mappable_regions_output,
                resources=compute.runtimes[machine_sizes.center],
        }
    }

    File center_sites_output = select_first([center_sites, get_center_sites.center_sites_starch])

    output {
        BowtieIndex bowtie_index_out = bowtie_index_output
        BwaIndex bwa_index_out = bwa_index_output
        File center_sites_out = center_sites_output
        File chrom_buckets_out = chrom_buckets_output
        File chrom_info_out = chrom_info_output
        File chrom_sizes_out = chrom_sizes_output
        File? fasta_index = build_fasta_index.indexed_fasta.fai
        File mappable_regions_out = mappable_regions_output
    }
}
