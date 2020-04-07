version 1.0


import "../tasks/samtools.wdl"


workflow get_number_of_reads_from_bam {
    input {
        File bam
        Resources resources
        SamtoolsViewParams params = object {
            count: true
        }
    }

    call samtools.view {
        input:
            in=bam,
            params=params,
            resources=resources,
    }

    output {
        Int count = read_int(view.out)
    }
}
