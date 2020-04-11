version 1.0


import "../../../wdl/subworkflows/make_big_bed_from_narrow_peak_bed.wdl" as bed


workflow test_make_big_bed_from_narrow_peak_bed {
    call bed.make_big_bed_from_narrow_peak_bed
}
