version 1.0


import "../tasks/samtools.wdl"


workflow filter_bam_reads_with_nonnuclear_flag {
    input {
        File flagged_and_marked_bam
        Int? nonnuclear_flag = 4096
        SamtoolsViewParams params = object {
            exclude: nonnuclear_flag,
            output_bam: true
        }
        Resources resources
    }

    call samtools.view {
        input:
            in=flagged_and_marked_bam,
            params=params,
            resources=resources,
    }

    output {
        File nuclear = view.out
    }
}
