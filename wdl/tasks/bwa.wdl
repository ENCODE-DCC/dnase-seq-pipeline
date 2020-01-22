version 1.0


import "../structs/bwa.wdl"


task index {
    input {
        File fasta
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
}


task aln {
    command {
        bwa aln
    }
}
