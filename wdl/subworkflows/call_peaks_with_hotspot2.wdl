version 1.0


import "../tasks/hotspot2.wdl" as nuclear_bam


workflow call_peaks_with_hotspot2 {
    input {
        File nuclear_bam
        HotSpot2Reference reference
        HotSpot2Params params = object {
            hotspot_threshold: 0.05,
            site_call_threshold: 0.5,
            peaks_definition: "varWidth_20_default"
        }
        Resources resources
    }

    call nuclear_bam.hotspot2 {
        input:
            nuclear_bam=nuclear_bam,
            reference=reference,
            params=params,
            resources=resources,
    }

    output {
        HotSpot2Peaks peaks = hotspot2.peaks
    }
}
