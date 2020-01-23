version 1.0


import "../tasks/bwa.wdl"


workflow build_bwa_index {
    input {
        File fasta
        Resources resources
    }

    call bwa.index {
        input:
            fasta=fasta,
            resources=resources
    }

    output {
        BWAIndex bwa_index = index.bwa_index
    }
}
