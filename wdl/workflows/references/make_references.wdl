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
        File reference_genome
    }

    call bwa.build_bwa_index {
    }

#    call fai.build_fasta_index {
#    }
#
#    call bowtie.build_bowtie_index {
#    }
#
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
        BwaIndex bwa_index = build_bwa_index.bwa_index
    }
}
