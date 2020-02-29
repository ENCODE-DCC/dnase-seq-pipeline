version 1.0


import "../tasks/hotspot1.wdl"


workflow get_hotspot1_score {
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

    output {
        File spot_score = runhotspot.spot_score
    }
}
