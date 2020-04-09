version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_mark_dups {
    input {
        File bam
        Resources resources
    }

    call stampipes.mark_dups {
        input:
            bam=bam,
            resources=resources,
    }
}
