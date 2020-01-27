version 1.0


import "../structs/resources.wdl
import "../structs/samtools.wdl"


task index_fasta {
    input {
        File fasta,
        String output_filename = "idx.faidx"
        Resources resources
    }

    String prefix = basename(fasta)

    command {
        ln ~{fasta}
        samtools faidx \
            ~{fasta} \
            -o ~{output_filename}
    }

    output {
        IndexedFasta indexed_fasta = {
            "fasta": prefix,
            "faidx": "~{prefix}.faidx"
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
