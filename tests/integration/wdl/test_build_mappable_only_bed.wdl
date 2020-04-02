version 1.0


import "../../../wdl/subworkflows/build_mappable_only_bed.wdl" as mappable


workflow test_build_mappable_only_bed {
    call mappable.build_mappable_only_bed
}
