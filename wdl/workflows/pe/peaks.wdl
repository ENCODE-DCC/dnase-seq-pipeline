version 1.0


import "../../../wdl/subworkflows/call_peaks_with_hotspot2.wdl" as nuclear_bam


workflow peaks {
    input {
        File nuclear_bam
        HotSpot2Reference reference
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")
    
    scatter (fdr in [0.05, 0.001]) {
        HotSpot2Params params = object {
            hotspot_threshold: fdr,
            site_call_threshold: 0.5,
            peaks_definition: "varWidth_20_default"
        }
        call nuclear_bam.call_peaks_with_hotspot2 {
            input:
                nuclear_bam=nuclear_bam,
                reference=reference,
                params=params,
                resources=compute.runtimes[machine_size],
        }
    }

    output {
        HotSpot2Peaks five_percent_peaks = call_peaks_with_hotspot2.peaks[0]
        HotSpot2Peaks tenth_of_one_percent_peaks = call_peaks_with_hotspot2.peaks[1]
    }
}
