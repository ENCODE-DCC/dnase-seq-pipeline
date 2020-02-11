version 1.0

import "../../tasks/samtools.wdl"


workflow filter {
    input {
        File flagged_and_marked_bam
        Map[String, Resources] runtimes
    }

    Int qc_fail_flag = 512
    Int non_nuclear_flag = 4096

    call samtools.view as filter_qc_fail {
        input:
            in=flagged_and_marked_bam,
            params={
                "binary": true,
                "exclude": qc_fail_flag
            },
            resources=runtimes['small'],
    }

    call samtools.view as filter_nuclear_chroms {
        input:
            in=filter_qc_fail.out,
            params={
                "binary": true,
                "exclude": non_nuclear_flag
            },
            resources=runtimes['small'],
    }

    output {
        File filtered = filter_qc_fail.out
        File nuclear = filter_nuclear_chroms.out
    }
}
