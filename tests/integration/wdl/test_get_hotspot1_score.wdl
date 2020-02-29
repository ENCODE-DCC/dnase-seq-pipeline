version 1.0


import "../../../wdl/subworkflows/get_hotspot1_score.wdl"


workflow test_get_hotspot1_score {
    call get_hotspot1_score.get_hotspot1_score
}
