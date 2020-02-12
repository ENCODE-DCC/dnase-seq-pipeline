version 1.0


import "../tasks/samtools.wdl"


workflow filter_bam_reads_with_nonnuclear_flag {
    input {
        File flagged_and_marked_bam
        String non_nuclear_flag = "4096"
        Resources resources
    }

    call samtools.view {
        input:
            in=flagged_and_marked_bam,
            params={
                "output_bam": true,
                "exclude": non_nuclear_flag
            },
            resources=resources,
    }

    output {
        File nuclear = view.out
    }
}
