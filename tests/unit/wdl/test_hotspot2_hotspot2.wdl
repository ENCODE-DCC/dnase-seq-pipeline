version 1.0


import "../../../wdl/tasks/hotspot2.wdl"


workflow test_hotspot2_hotspot2 {
    input {
        File nuclear_bam
        HotSpot2Reference reference
        HotSpot2Params params
        Resources resources
    }

    call hotspot2.hotspot2 {
        input:
            nuclear_bam=nuclear_bam,
            reference=reference,
            params=params,
            resources=resources,
    }
}
