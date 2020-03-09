version 1.0


import "../../../wdl/tasks/bedops.wdl"


workflow test_bedops_bam2bed {
    input {
        File bam
        BedopsBam2BedParams params
        Resources resources
    }

    call bedops.bam2bed {
        input:
            bam=bam,
            params=params,
            resources=resources,
    }
}
