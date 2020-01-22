version 1.0


import "..tasks/bwa.wdl"


workflow build_bwa_index {
    input {
        File fasta
    }

    call bwa.index {
        input:
            fasta=fasta
    }
}

