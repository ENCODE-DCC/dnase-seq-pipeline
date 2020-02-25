version 1.0


import "../tasks/samtools.wdl"


workflow get_first_read_in_pair_from_bam {
    input {
        File paired_end_bam
        Int? first_in_pair_flag = 64
        Resources resources
        SamtoolsViewParams params = object {
            include: first_in_pair_flag,
            output_bam: true
        }
        String? out_path = "first_in_pair.bam"
    }

    call samtools.view {
        input:
            in=paired_end_bam,
            params=params,
            resources=resources,
            out_path=out_path,
    }

    output {
        File first_in_pair_bam = view.out
    }
}
