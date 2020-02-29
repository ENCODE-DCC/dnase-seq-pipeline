version 1.0


import "../../../wdl/subworkflows/get_hotspot2_info.wdl"


workflow test_get_hotspot2_info {
    call get_hotspot2_info.get_hotspot2_info
}
