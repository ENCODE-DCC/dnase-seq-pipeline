version 1.0


import "../../../wdl/subworkflows/subtract_blacklists_from_mappable_regions.wdl"


workflow test_subtract_blacklists_from_mappable_regions {
    call subtract_blacklists_from_mappable_regions.subtract_blacklists_from_mappable_regions {
    }
}
