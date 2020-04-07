version 1.0


import "../../../wdl/tasks/samtools.wdl"


workflow test_faidx {
    input {
        File fasta
        Resources resources
    }

    call samtools.faidx {
        input:
            fasta=fasta,
            resources=resources,
    }
}
