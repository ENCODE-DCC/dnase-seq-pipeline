version 1.0


import "../tasks/cat.wdl"
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

    call cat.get_int_from_file {
        input:
            in=view.out,
            resources=resources,
    }

    output {
        Int count = get_int_from_file.out
    }
}
