version 1.0


import "../../../wdl/tasks/samtools.wdl"


workflow test_samtools_stats {
    input {
        File bam
        Resources resources
    }

    call samtools.stats {
        input:
            bam=bam,
            resources=resources,
    }
}
