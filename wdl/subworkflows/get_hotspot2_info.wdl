version 1.0


import "../tasks/stampipes.wdl"


workflow get_hotspot2_info {
    input {
        File hotspots
        File spot_score
        Resources resources
        String? out
    }

    call stampipes.info {
        input:
            hotspots=hotspots,
            spot_score=spot_score,
            spot_type="hotspot2",
            resources=resources,
            out=out,
    }

    output {
        File hotspot2_info = info.hotspot_info
    }
}
