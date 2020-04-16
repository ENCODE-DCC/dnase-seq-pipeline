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
        String machine_size_bwa = "large"
        String machine_size_fai = "large"
        String machine_size_bowtie = "large"
    }

    Machines compute = read_json("wdl/runtimes.json")

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

#    call mappable.build_mappable_only_bed {
#    }
#
#    call chr_buckets.get_chrombuckets {
#    }
#
#    call chr_sizes.get_chrom_sizes {
#    }
#
#    call chr_info.get_chrom_info {
#    }
#
#    call center.get_center_sites {
#    }

    output {
        BowtieIndex bowtie_index = build_bowtie_index.bowtie_index
        BwaIndex bwa_index = build_bwa_index.bwa_index
        File? fasta_index = build_fasta_index.indexed_fasta.fai
    }
}
