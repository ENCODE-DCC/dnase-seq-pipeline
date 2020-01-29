version 1.0


import "../../wdl/tasks/bowtie.wdl"


workflow test_bowtie_index {
    input {
        File fasta
        Resources resources
    }

    call bowtie.index {
        input:
            fasta=fasta,
            resources=resources,
    }
}
