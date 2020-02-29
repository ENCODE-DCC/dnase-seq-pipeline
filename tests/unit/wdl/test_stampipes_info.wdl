version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_info {
    input {
         File hotspots
         File spot_score
         File spot_type
         Resources resources
         String? out
    }

    call stampipes.info {
        input:
            hotspots=hotspots,
            spot_score=spot_score,
            spot_type=spot_type,
            resources=resources,
            out=out,
    }
}
