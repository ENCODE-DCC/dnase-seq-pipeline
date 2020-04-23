version 1.0


import "../../subworkflows/build_bowtie_index.wdl" as bowtie
import "../../subworkflows/build_bwa_index.wdl" as bwa
import "../../subworkflows/build_fasta_index.wdl" as fai
import "../../subworkflows/build_mappable_only_bed.wdl" as mappable
import "../../subworkflows/get_center_sites.wdl" as center
import "../../subworkflows/get_chrombuckets.wdl" as chr_buckets
import "../../subworkflows/get_chrom_info.wdl" as chr_info
import "../../subworkflows/get_chrom_sizes.wdl" as chr_sizes


workflow make_references {
    input {
        File reference_fasta
        Int mappability_kmer_length
        String machine_size_bwa = "large"
        String machine_size_center = "large"
        String machine_size_chr_buckets = "large"
        String machine_size_chr_info = "medium"
        String machine_size_chr_sizes = "large"
        String machine_size_fai = "large"
        String machine_size_bowtie = "large"
        String machine_size_mappable = "large"
    }

    Machines compute = read_json("wdl/runtimes.json")
    String genome_name = basename(reference_fasta, ".fa")

    call bwa.build_bwa_index {
        input:
            fasta=reference_fasta,
            resources=compute.runtimes[machine_size_bwa],
    }

    call fai.build_fasta_index {
        input:
            fasta=reference_fasta,
            resources=compute.runtimes[machine_size_fai],
    }

    call bowtie.build_bowtie_index {
        input:
            fasta=reference_fasta,
            resources=compute.runtimes[machine_size_bowtie]
    }

    call mappable.build_mappable_only_bed {
        input:
            bowtie_index=build_bowtie_index.bowtie_index,
            kmer_length=mappability_kmer_length,
            reference_genome=reference_fasta,
            resources=compute.runtimes[machine_size_mappable],
    }

    call chr_buckets.get_chrombuckets {
        input:
            fai=select_first([build_fasta_index.indexed_fasta.fai]),
            genome_name=genome_name,
            resources=compute.runtimes[machine_size_chr_buckets],
    }

    call chr_sizes.get_chrom_sizes {
        input:
            fai=select_first([build_fasta_index.indexed_fasta.fai]),
            resources=compute.runtimes[machine_size_chr_sizes],
    }

    call chr_info.get_chrom_info {
        input:
            chrom_sizes=get_chrom_sizes.chrom_sizes,
            resources=compute.runtimes[machine_size_chr_info],
    }

    call center.get_center_sites {
        input:
            chrom_sizes=get_chrom_sizes.chrom_sizes,
            mappable_regions=build_mappable_only_bed.mappable_regions,
            resources=compute.runtimes[machine_size_center],

    }

    output {
        BowtieIndex bowtie_index = build_bowtie_index.bowtie_index
        BwaIndex bwa_index = build_bwa_index.bwa_index
        File center_sites_starch = get_center_sites.center_sites_starch
        File chrom_buckets = get_chrombuckets.chrombuckets
        File chrom_info = get_chrom_info.chrom_info
        File chrom_sizes = get_chrom_sizes.chrom_sizes
        File? fasta_index = build_fasta_index.indexed_fasta.fai
        File mappable_regions = build_mappable_only_bed.mappable_regions
    }
}
