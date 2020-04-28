version 1.0


import "../../../wdl/subworkflows/find_significant_footprints.wdl"


workflow test_find_significant_footprints {
    call find_significant_footprints.find_significant_footprints
}
