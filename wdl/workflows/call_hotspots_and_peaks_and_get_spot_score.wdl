version 1.0


import "../../wdl/workflows/pe/peaks.wdl" as nuclear_bam_for_peaks
import "../../wdl/workflows/pe/score.wdl" as nuclear_bam_for_score


workflow call_hotspots_and_peaks_and_get_spot_score {
    input {
        File nuclear_bam
        String machine_size_peaks = "medium"
        String machine_size_score = "medium"
    }

    call nuclear_bam_for_peaks.peaks {
        input:
            nuclear_bam=nuclear_bam,
            machine_size=machine_size_peaks,
    }

    call nuclear_bam_for_score.score {
        input:
            nuclear_bam=nuclear_bam,
            machine_size=machine_size_score,
    }

    output {
        HotSpot2Peaks five_percent_peaks = peaks.five_percent_peaks
        HotSpot2Peaks tenth_of_one_percent_peaks = peaks.tenth_of_one_percent_peaks
        File spot_score = score.spot_score
    }
}
