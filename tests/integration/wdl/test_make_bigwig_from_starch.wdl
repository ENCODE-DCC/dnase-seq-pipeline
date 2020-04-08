version 1.0


import "../../../wdl/subworkflows/make_bigwig_from_starch.wdl" as starch


workflow test_make_bigwig_from_starch {
    call starch.make_bigwig_from_starch
}
