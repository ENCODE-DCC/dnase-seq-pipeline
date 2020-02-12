version 1.0


import "../subworkflows/add_mate_cigar_to_bam.wdl" as sorted_bam
import "../subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as mate_cigar_bam
import "../subworkflows/mark_duplicates_in_bam_and_get_duplication_metrics.wdl" as qc_fail_flagged_bam


workflow mark {
    input {
        File sorted_bam
        File nuclear_chroms
        String machine_size
    }

    Machines compute = read_json("../runtimes.json")

    call sorted_bam.add_mate_cigar_to_bam {
        input:
            bam=sorted_bam,
            resources=compute.runtimes[machine_size],
    }

    call mate_cigar_bam.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
        input:
            bam=add_mate_cigar_to_bam.mate_cigar_bam,
            nuclear_chroms=nuclear_chroms,
            resources=compute.runtimes[machine_size],
    }

    call qc_fail_flagged_bam.mark_duplicates_in_bam_and_get_duplication_metrics {
        input:
            bam=flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.flagged_bam,
            resources=compute.runtimes[machine_size],
    }

    output {
        File flagged_and_marked_bam = mark_duplicates_in_bam_and_get_duplication_metrics.marked
        File duplication_metrics = mark_duplicates_in_bam_and_get_duplication_metrics.metrics
    }
}
