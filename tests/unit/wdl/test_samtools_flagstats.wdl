version 1.0

import "../../../wdl/tasks/samtools.wdl"


workflow test_samtools_flagstats {
    input {
        File bam
        Resources resources
    }

    call samtools.flagstats {
        input:
            bam=bam,
            resources=resources,
    }
}
