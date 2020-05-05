version 1.0


import "../tasks/hotspot2.wdl" as nuclear_bam
import "get_counts_from_hotspot2_peaks.wdl" as unstarch


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

    call unstarch.get_counts_from_hotspot2_peaks {
        input:
            allcalls=hotspot2.peaks.allcalls,
            hotspots=hotspot2.peaks.hotspots,
            narrowpeaks=hotspot2.peaks.narrowpeaks,
            resources=resources,
    }

    output {
        HotSpot2Peaks peaks = object {
            allcalls: hotspot2.peaks.allcalls,
            allcalls_count: get_counts_from_hotspot2_peaks.allcalls_count,
            cleavage: hotspot2.peaks.cleavage,
            cutcounts: hotspot2.peaks.cutcounts,
            density_starch: hotspot2.peaks.density_starch,
            density_bw: hotspot2.peaks.density_bw,
            fragments: hotspot2.peaks.fragments,
            hotspots: hotspot2.peaks.hotspots,
            hotspots_count: get_counts_from_hotspot2_peaks.hotspots_count,
            peaks: hotspot2.peaks.peaks,
            narrowpeaks: hotspot2.peaks.narrowpeaks,
            narrowpeaks_count: get_counts_from_hotspot2_peaks.narrowpeaks_count,
            spot_score: hotspot2.peaks.spot_score
        }
    }
}
