version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_get_preseq_targets {
    input {
        File preseq
        Resources resources
    }

    call stampipes.get_preseq_targets {
        input:
            preseq=preseq,
            resources=resources,
    }
}
