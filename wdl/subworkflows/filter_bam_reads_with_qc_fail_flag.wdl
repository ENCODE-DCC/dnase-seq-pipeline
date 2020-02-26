version 1.0


import "../tasks/samtools.wdl"


workflow filter_bam_reads_with_qc_fail_flag {
    input {
        File flagged_bam
        Int qc_fail_flag = 512
        Resources resources
        SamtoolsViewParams params = object {
            exclude: qc_fail_flag,
            output_bam: true
        }
        String out_path = "qc_fail_flag_filtered.bam"
    }

    call samtools.view {
        input:
            in=flagged_bam,
            params=params,
            resources=resources,
            out_path=out_path,
    }

    output {
        File filtered = view.out
    }
}
