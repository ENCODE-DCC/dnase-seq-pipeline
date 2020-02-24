version 1.0


import "../../../wdl/tasks/hotspot1.wdl"


workflow test_hotspot1_runhotspot {
    input {
        File subsampled_bam
        HotSpot1Index index
        HotSpot1Params params
        Resources resources
    }

    call hotspot1.runhotspot {
        input:
            subsampled_bam=subsampled_bam,
            index=index,
            params=params,
            resources=resources,
    }
}
