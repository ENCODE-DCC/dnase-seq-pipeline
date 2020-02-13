version 1.0

import "wdl/subworkflows/filter_bam_reads_with_qc_fail_flag.wdl" as qc
import "wdl/subworkflows/filter_bam_reads_with_nonnuclear_flag.wdl" as nuclear


workflow filter {
    input {
        File flagged_and_marked_bam
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")

    call qc.filter_bam_reads_with_qc_fail_flag {
        input:
            flagged_bam=flagged_and_marked_bam,
            resources=compute.runtimes[machine_size],
    }

    call nuclear.filter_bam_reads_with_nonnuclear_flag {
        input:
            flagged_bam=filter_bam_reads_with_qc_fail_flag.filtered,
            resources=compute.runtimes[machine_size],
    }

    output {
        File filtered = filter_bam_reads_with_qc_fail_flag.filtered
        File nuclear = filter_bam_reads_with_nonnuclear_flag.nuclear
    }
}
