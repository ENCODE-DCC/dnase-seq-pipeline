version 1.0


import "../../../wdl/tasks/bedops.wdl"


workflow test_bedops_bedmap {
    input {
        File sorted_reference_bed_or_starch
        File sorted_map_bed_or_starch
        BedopsBedMapParams params
        Resources resources
    }

    call bedops.bedmap {
        input:
            sorted_reference_bed_or_starch=sorted_reference_bed_or_starch,
            sorted_map_bed_or_starch=sorted_map_bed_or_starch,
            params=params,
            resources=resources,
    }
}
