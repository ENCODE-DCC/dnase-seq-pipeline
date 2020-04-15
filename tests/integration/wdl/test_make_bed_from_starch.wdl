version 1.0


import "../../../wdl/subworkflows/make_bed_from_starch.wdl" as unstarch


workflow test_make_bed_from_starch {
    call unstarch.make_bed_from_starch
}
