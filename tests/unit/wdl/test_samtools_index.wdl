version 1.0


import "../../../wdl/tasks/samtools.wdl"


workflow test_samtools_index {
    input {
        File bam
        Resources resources
    }

    call samtools.index {
        input:
            bam=bam,
            resources=resources,
    }
}
