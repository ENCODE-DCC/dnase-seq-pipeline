version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_bamcounts {
    input {
        File bam
        Resources resources
    }

    call stampipes.bamcounts {
        input:
            bam=bam,
            resources=resources,
    }
}
