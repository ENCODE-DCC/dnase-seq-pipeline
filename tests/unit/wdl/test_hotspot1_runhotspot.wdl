version 1.0


import "../../../wdl/tasks/hotspot1.wdl"


workflow test_hotspot1_runhotspot {
    input {
        File subsampled_bam
        HotSpot1Reference reference
        HotSpot1Params params
        Resources resources
    }

    call hotspot1.runhotspot {
        input:
            subsampled_bam=subsampled_bam,
            reference=reference,
            params=params,
            resources=resources,
    }
}
