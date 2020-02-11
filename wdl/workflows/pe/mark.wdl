version 1.0


import "../../subworkflows/add_mate_cigar_to_bam.wdl" as cigar
import "../../subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as qc
import "../../subworkflows/mark_duplicates_in_bam_and_get_duplication_metrics.wdl" as duplicates


workflow mark {
    input {
        File sorted_bam
        File nuclear_chroms
        Map[String, Resources] runtimes
    }

    call cigar.add_mate_cigar_to_bam {
        input:
            bam=sorted_bam,
            resources=runtimes['small'],
    }

    call qc.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
        input:
            bam=add_mate_cigar_to_bam.mate_cigar_bam,
            nuclear_chroms=nuclear_chroms,
            resources=runtimes['small'],
    }

    call duplicates.mark_duplicates_in_bam_and_get_duplication_metrics {
        input:
            bam=flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.flagged_bam,
            resources=runtimes['small'],
    }

    output {
        File flagged_and_marked_bam = mark_duplicates_in_bam_and_get_duplication_metrics.marked
        File duplication_metrics = mark_duplicates_in_bam_and_get_duplication_metrics.metrics
    }
}
