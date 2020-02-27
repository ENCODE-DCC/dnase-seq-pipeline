version 1.0


import "../../../wdl/subworkflows/get_bamcounts.wdl"


workflow test_get_bamcounts {
    call get_bamcounts.get_bamcounts {
    }
}
