version 1.0


import "../../../wdl/subworkflows/call_peaks_with_hotspot2.wdl"


workflow test_call_peaks_with_hotspot2 {
    call call_peaks_with_hotspot2.call_peaks_with_hotspot2
}
