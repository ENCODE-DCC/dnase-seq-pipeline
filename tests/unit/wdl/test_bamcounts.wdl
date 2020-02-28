version 1.0


import "../../../wdl/tasks/bamcounts.wdl"


workflow test_bamcounts {
    input {
        File bam
        Resources resources
    }

    call bamcounts.bamcounts {
        input:
            bam=bam,
            resources=resources,
    }
}
