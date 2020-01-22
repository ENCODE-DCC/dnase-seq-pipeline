version 1.0


import "../structs/bwa.wdl"
import "../structs/resources.wdl"


task index {
    input {
        File fasta
        Resources resources
    }

    String prefix = basename(fasta)

    command {
        cp ~{fasta} ~{prefix}
        bwa index ~{prefix}
    }

    output {
        BWAIndex bwa_index = {
            "fasta": prefix,
            "amb": "~{prefix}.amb",
            "ann": "~{prefix}.ann",
            "bwt": "~{prefix}.bwt",
            "pac": "~{prefix}.pac",
            "sa": "~{prefix}.sa"
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task aln {
    command {
        bwa aln
    }
}
