version 1.0


import "../../../wdl/subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as merged_bam
import "../../../wdl/subworkflows/sort_bam_by_coordinate.wdl" as flagged_bam
import "../../../wdl/subworkflows/add_mate_cigar_to_bam.wdl" as coordinate_sorted_bam
import "../../../wdl/subworkflows_old_mark_duplicates/mark_duplicates_in_bam_and_get_duplication_metrics_old_mark_duplicates.wdl" as mate_cigar_bam
import "../../../wdl/subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl"


workflow mark {
    input {
        File merged_bam
        File nuclear_chroms
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")
    String machine_size_low_cpu = machine_size + "-low-cpu"

    call merged_bam.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
        input:
            bam=merged_bam,
            nuclear_chroms=nuclear_chroms,
            resources=compute.runtimes[machine_size_low_cpu],
    }

    call flagged_bam.sort_bam_by_coordinate {
        input:
            bam=flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.flagged_bam,
            resources=compute.runtimes[machine_size],
    }

    call coordinate_sorted_bam.add_mate_cigar_to_bam {
        input:
            bam=sort_bam_by_coordinate.sorted_bam,
            resources=compute.runtimes[machine_size_low_cpu],
    }

    call mate_cigar_bam.mark_duplicates_in_bam_and_get_duplication_metrics {
        input:
            bam=add_mate_cigar_to_bam.mate_cigar_bam,
            resources=compute.runtimes[machine_size_low_cpu],
    }

    output {
        File flagged_and_marked_bam = mark_duplicates_in_bam_and_get_duplication_metrics.marked
        File duplication_metrics = mark_duplicates_in_bam_and_get_duplication_metrics.metrics
    }
}
