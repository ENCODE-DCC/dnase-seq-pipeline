version 1.0


import "../../../wdl/subworkflows/make_gz_bed_from_bed.wdl" as bed


workflow test_make_gz_bed_from_bed {
    call bed.make_gz_bed_from_bed
}
