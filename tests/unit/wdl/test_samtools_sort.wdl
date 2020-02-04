version 1.0

import "../../../wdl/tasks/samtools.wdl"


workflow test_samtools_sort {
    input {
        File bam
        SamtoolsSortParams params
        Resources resources
        String? out
    }

    call samtools.sort {
        input:
            bam=bam,
            out=out,
            params=params,
            resources=resources,
    }
}
