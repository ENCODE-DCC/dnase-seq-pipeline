version 1.0


import "../flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as flag_qc
import "../mark_duplicates_in_bam_and_get_duplication_metrics.wdl" as flag_duplicates


workflow mark {
    input {
        File sorted_bam
    }

    call flag_qc.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
        in=sorted_bam
    }

    call flag_duplicates.mark_duplicates_in_bam_and_get_duplication_metric {
        in=flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.out
    }

    output {
        File flagged_and_marked_bam = mark_duplicates_in_bam_and_get_duplication_metric.marked
        File duplicate_metrics = mark_duplicates_in_bam_and_get_duplication_metric.metrics
    }
}
