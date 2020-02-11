version 1.0


import "../../subworkflows/add_mate_cigar_to_bam.wdl" as cigar
import "../../subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as qc
import "../../subworkflows/mark_duplicates_in_bam_and_get_duplication_metrics.wdl" as duplicates


workflow mark {
    input {
        File sorted_bam
    }

    call cigar.add_mate_cigar_to_bam {
        input:
            bam=sorted_bam
    }

    call qc.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
        input:
            bam=mate_cigar_to_bam.mate_cigar_bam
    }

    call duplicates.mark_duplicates_in_bam_and_get_duplication_metric {
        input:
            bam=flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.flagged_bam
    }

    output {
        File flagged_and_marked_bam = mark_duplicates_in_bam_and_get_duplication_metric.marked
        File duplicate_metrics = mark_duplicates_in_bam_and_get_duplication_metric.metrics
    }
}
