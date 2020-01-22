version 1.0


import "../structs/bwa_struct.wdl"


task index {
    input {
        File fasta
    }

    String prefix = basename(fasta)

    command {
        bwa index \
        -p ~{prefix} \
        ~{fasta}
    }

    output {
        BWAIndex bwa_index = {
            "fasta": fasta,
            "amb": "~{prefix}.amb",
            "ann": "~{prefix}.ann",
            "bwt": "~{prefix}.bwt",
            "pac": "~{prefix}.pac",
            "sa": "~{prefix}.sa"
        }
    }
}


task aln {
    command {
        bwa aln
    }
}
