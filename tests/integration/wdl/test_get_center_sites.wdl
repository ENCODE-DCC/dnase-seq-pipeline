version 1.0


import "../../../wdl/subworkflows/get_center_sites.wdl"


workflow test_get_center_sites {
    call get_center_sites.get_center_sites 
}
