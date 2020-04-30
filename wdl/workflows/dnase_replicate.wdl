version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "concatenate_trim_and_align_fastqs.wdl" as raw_fastqs
import "merge_mark_and_filter_bams.wdl" as name_sorted_bams
import "call_hotspots_and_peaks_and_get_spot_score.wdl" as nuclear_bam
import "call_footprints.wdl" as hotspots
import "calculate_and_gather_qc.wdl" as qc_files 
import "normalize_and_convert_files.wdl" as bams_and_peaks


workflow dnase_replicate {
    input {
        Replicate replicate
        References references
        MachineSizes machine_sizes = read_json("wdl/default_machine_sizes.json")
    }

    call raw_fastqs.concatenate_trim_and_align_fastqs {
        input:
            replicate=replicate,
            references=references,
            machine_sizes=machine_sizes,
    }

    call name_sorted_bams.merge_mark_and_filter_bams {
        input:
            name_sorted_bams=concatenate_trim_and_align_fastqs.name_sorted_bams,
            references=references,
            machine_sizes=machine_sizes,
    }

    call nuclear_bam.call_hotspots_and_peaks_and_get_spot_score {
        input:
            nuclear_bam=merge_mark_and_filter_bams.nuclear_bam,
            replicate=replicate,
            references=references,
            machine_sizes=machine_sizes,
    }

    call hotspots.call_footprints {
        input:
            five_percent_hotspots_starch=call_hotspots_and_peaks_and_get_spot_score.five_percent_peaks.hotspots,
            nuclear_bam=merge_mark_and_filter_bams.nuclear_bam,
            references=references,
            machine_sizes=machine_sizes,
    }

    call qc_files.calculate_and_gather_qc {
        input:
            files_for_calculation=object {
               unfiltered_bam: merge_mark_and_filter_bams.unfiltered_bam,
               nuclear_bam: merge_mark_and_filter_bams.nuclear_bam
            },
            files_to_gather=object {
                duplication_metrics: merge_mark_and_filter_bams.duplication_metrics,
                spot_score: call_hotspots_and_peaks_and_get_spot_score.spot_score,
                trimstats: concatenate_trim_and_align_fastqs.trimstats,
                five_percent_peaks: call_hotspots_and_peaks_and_get_spot_score.five_percent_peaks
            },
            replicate=replicate,
            machine_sizes=machine_sizes,
    }

    call bams_and_peaks.normalize_and_convert_files {
        input:
            nuclear_bam=merge_mark_and_filter_bams.nuclear_bam,
            one_percent_footprints_bed=call_footprints.one_percent_footprints_bed,
            five_percent_peaks=call_hotspots_and_peaks_and_get_spot_score.five_percent_peaks,
            references=references,
            machine_sizes=machine_sizes,
    }

    output {
        File unfiltered_bam = merge_mark_and_filter_bams.unfiltered_bam
        File nuclear_bam = merge_mark_and_filter_bams.nuclear_bam
        File normalized_density_bw = normalize_and_convert_files.normalized_density_bw
        File five_percent_allcalls_bed_gz = normalize_and_convert_files.five_percent_allcalls_bed_gz
        File five_percent_narrowpeaks_bed_gz = normalize_and_convert_files.five_percent_narrowpeaks_bed_gz
        File five_percent_narrowpeaks_bigbed = normalize_and_convert_files.five_percent_narrowpeaks_bigbed
        File one_percent_footprints_bed_gz = normalize_and_convert_files.one_percent_footprints_bed_gz
        File one_percent_footprints_bigbed = normalize_and_convert_files.one_percent_footprints_bigbed
        QC qc = object {
            unfiltered_bam_qc: calculate_and_gather_qc.unfiltered_bam_qc,
            nuclear_bam_qc: calculate_and_gather_qc.nuclear_bam_qc,
            peaks_qc: calculate_and_gather_qc.peaks_qc
        }
    }
}
