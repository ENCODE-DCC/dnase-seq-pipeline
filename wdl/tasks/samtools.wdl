version 1.0


import "../structs/resources.wdl"
import "../structs/samtools.wdl"


task index_fasta {
    input {
        File fasta
        Resources resources
    }

    String prefix = basename(fasta)

    command {
        ln ~{fasta} .
        samtools faidx ~{prefix}
    }

    output {
        IndexedFasta indexed_fasta = {
            "fasta": prefix,
            "fai": "~{prefix}.fai"
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
