version 1.0


import "../../../wdl/subworkflows/get_chrombuckets.wdl"


workflow test_get_chrombuckets {
    call get_chrombuckets.get_chrombuckets
}
