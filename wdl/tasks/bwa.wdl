version 1.0



task aln {
    command {
        bwa aln
    }
}

#Tasks related to bwa

import "../structs/bwa_struct.wdl"

task index {
    File genome_reference_fasta
    String output_prefix
    Int cpu
    Int ramGB
    String disks

    command {
        bwa index -p ~{output_prefix} ~{genome_reference_fasta}
    }

    output {
        BWAIndex bwa_index = { 
            "amb" : "~{output_prefix}.amb"
            "ann" : "~{output_prefix}.ann"
            "bwt" : "~{output_prefix}.bwt"
            "pac" : "~{output_prefix}.pac"
            "sa" : "~{output_prefix}.sa"
        }
    }

    runtime {
        cpu: cpu
        ramGB: ramGB,
        disks: disks
    }
}

