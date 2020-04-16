version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "concatenate_trim_and_align_pe_fastqs.wdl" as pe_fastqs
import "concatenate_trim_and_align_se_fastqs.wdl" as se_fastqs
import "merge_mark_and_filter_bams.wdl" as name_sorted_bams
import "call_hotspots_and_peaks_and_get_spot_score.wdl" as nuclear_bam
import "calculate_qc_and_normalize_and_convert_files.wdl" as bams_and_peaks


workflow dnase_replicate {
    input {
        Replicate replicate
        References references
        MachineSizes machine_sizes = read_json("wdl/default_machine_sizes.json")
    }

    if (defined(replicate.pe_fastqs)) {
        call pe_fastqs.concatenate_trim_and_align_pe_fastqs {
            input:
                replicate=replicate,
                references=references,
                machine_sizes=machine_sizes,
        }
    }

    if (defined(replicate.se_fastqs)) {
        call se_fastqs.concatenate_trim_and_align_se_fastqs {
            input:
                replicate=replicate,
                references=references,
                machine_sizes=machine_sizes,
        }
    }

    Array[File] name_sorted_bams = select_all([
        concatenate_trim_and_align_pe_fastqs.name_sorted_bam,
        concatenate_trim_and_align_se_fastqs.name_sorted_bam
    ])

    call name_sorted_bams.merge_mark_and_filter_bams {
        input:
            name_sorted_bams=name_sorted_bams,
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

    call bams_and_peaks.calculate_qc_and_normalize_and_convert_files {
        input:
            unfiltered_bam=merge_mark_and_filter_bams.unfiltered_bam,
            nuclear_bam=merge_mark_and_filter_bams.nuclear_bam,
            duplication_metrics=merge_mark_and_filter_bams.duplication_metrics,
            spot_score=call_hotspots_and_peaks_and_get_spot_score.spot_score,
            trimstats=concatenate_trim_and_align_pe_fastqs.trimstats,
            five_percent_peaks=call_hotspots_and_peaks_and_get_spot_score.five_percent_peaks,
            references=references,
            machine_sizes=machine_sizes,
    }

    output {
        File unfiltered_bam = merge_mark_and_filter_bams.unfiltered_bam
        File nuclear_bam = merge_mark_and_filter_bams.nuclear_bam
        File normalized_density_bw = calculate_qc_and_normalize_and_convert_files.normalized_density_bw
        File five_percent_allcalls_bed_gz = calculate_qc_and_normalize_and_convert_files.five_percent_allcalls_bed_gz
        File five_percent_narrowpeaks_bed_gz = calculate_qc_and_normalize_and_convert_files.five_percent_narrowpeaks_bed_gz
        File five_percent_narrowpeaks_bigbed = calculate_qc_and_normalize_and_convert_files.five_percent_narrowpeaks_bigbed
        UnfilteredBamQC unfiltered_bam_qc = calculate_qc_and_normalize_and_convert_files.unfiltered_bam_qc
        NuclearBamQC nuclear_bam_qc = calculate_qc_and_normalize_and_convert_files.nuclear_bam_qc
        PeaksQC peaks_qc = calculate_qc_and_normalize_and_convert_files.peaks_qc

    }
}
