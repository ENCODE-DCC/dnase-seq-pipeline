version 1.0


import "../../../wdl/subworkflows/get_counts_from_hotspot2_peaks.wdl" as peaks


workflow test_get_counts_from_hotspot2_peaks {
    call peaks.get_counts_from_hotspot2_peaks
}
