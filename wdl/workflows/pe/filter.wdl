version 1.0

import "../../subworkflows/filter_bam_reads_with_qc_fail_flag.wdl" as qc
import "../../subworkflows/filter_bam_reads_with_non_nuclear_flag.wdl" as nuclear


workflow filter {
    input {
        File flagged_and_marked_bam
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")

    call qc.filter_bam_reads_with_qc_fail_flag {
        input:
            flagged_and_marked_bam=flagged_and_marked_bam,
            resources=compute.runtimes[machine_size],
    }

    call nuclear.filter_bam_reads_with_non_nuclear_flag {
        input:
            flagged_and_marked_bam=filter_bam_reads_with_qc_fail_flag.filtered,
            resources=compute.runtimes[machine_size],
    }

    output {
        File filtered = filter_bam_reads_with_qc_fail_flag.filtered
        File nuclear = filter_bam_reads_with_non_nuclear_flag.nuclear
    }
}
