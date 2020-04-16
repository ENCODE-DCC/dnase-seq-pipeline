version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/workflows/mixed/peaks.wdl" as nuclear_bam_for_peaks
import "../../wdl/workflows/mixed/score.wdl" as nuclear_bam_for_score


workflow call_hotspots_and_peaks_and_get_spot_score {
    input {
        File nuclear_bam
        Replicate replicate
        References references
        MachineSizes machine_sizes
    }

    call nuclear_bam_for_peaks.peaks {
        input:
            nuclear_bam=nuclear_bam,
            reference=select_first([
                references.hotspot2
            ]),
            machine_size=machine_sizes.peaks,
    }

    call nuclear_bam_for_score.score {
        input:
            nuclear_bam=nuclear_bam,
            reference=select_first([
                references.hotspot1
            ]),
            params=object {
                genome_name: references.genome_name,
                read_length: replicate.read_length
            },
            machine_size=machine_sizes.score,
    }

    output {
        HotSpot2Peaks five_percent_peaks = peaks.five_percent_peaks
        HotSpot2Peaks tenth_of_one_percent_peaks = peaks.tenth_of_one_percent_peaks
        File spot_score = score.spot_score
    }
}
