version 1.0


import "../structs/bowtie.wdl"
import "../structs/resources.wdl"


task index {
    input {
        File fasta
        Resources resources
    }

    String prefix = basename(fasta)

    command {
        bowtie-build ~{fasta} ~{prefix}
    }

    output {
        BowtieIndex bowtie_index = {
            "ebwt_1": "~{prefix}.1.ebwt",
            "ebwt_2": "~{prefix}.2.ebwt",
            "ebwt_3": "~{prefix}.3.ebwt",
            "ebwt_4": "~{prefix}.4.ebwt",
            "rev_ebwt1": "~{prefix}.rev.1.ebwt",
            "rev_ebwt2": "~{prefix}.rev.2.ebwt"  
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
