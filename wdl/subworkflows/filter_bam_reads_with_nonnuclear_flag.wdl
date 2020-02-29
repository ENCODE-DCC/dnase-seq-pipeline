version 1.0


import "../tasks/samtools.wdl"


workflow filter_bam_reads_with_nonnuclear_flag {
    input {
        File flagged_bam
        Int? nonnuclear_flag = 4096
        Resources resources
        SamtoolsViewParams params = object {
            exclude: nonnuclear_flag,
            output_bam: true
        }
        String? out_path = "nuclear.bam"
    }

    call samtools.view {
        input:
            in=flagged_bam,
            params=params,
            resources=resources,
            out_path=out_path,
    }

    output {
        File nuclear = view.out
    }
}
