version 1.0


import "../../../wdl/subworkflows/threshold_footprints_and_make_bed.wdl"


workflow test_threshold_footprints_and_make_bed {
    call threshold_footprints_and_make_bed.threshold_footprints_and_make_bed
}
