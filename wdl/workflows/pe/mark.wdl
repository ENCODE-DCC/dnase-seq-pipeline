version 1.0


import "../../../wdl/subworkflows/add_mate_cigar_to_bam.wdl" as sorted_bam
import "../../../wdl/subworkflows/mark_duplicates_in_bam_and_get_duplication_metrics.wdl" as mate_cigar_bam
import "../../../wdl/subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as duplicate_marked_bam


workflow mark {
    input {
        File sorted_bam
        File nuclear_chroms
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")

    call sorted_bam.add_mate_cigar_to_bam {
        input:
            bam=sorted_bam,
            resources=compute.runtimes[machine_size],
    }

    call mate_cigar_bam.mark_duplicates_in_bam_and_get_duplication_metrics {
        input:
            bam=add_mate_cigar_to_bam.mate_cigar_bam,
            resources=compute.runtimes[machine_size],
    }

    call duplicate_marked_bam.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
        input:
            bam=mark_duplicates_in_bam_and_get_duplication_metrics.marked,
            nuclear_chroms=nuclear_chroms,
            resources=compute.runtimes[machine_size],
    }

    output {
        File flagged_and_marked_bam = flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.flagged_bam
        File duplication_metrics = mark_duplicates_in_bam_and_get_duplication_metrics.metrics
    }
}
