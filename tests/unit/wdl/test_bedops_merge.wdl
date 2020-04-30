version 1.0


import "../../../wdl/tasks/bedops.wdl"


workflow test_bedops_merge {
    input {
        File sorted_bed
        Resources resources
    }

    call bedops.merge {
        input:
            sorted_bed=sorted_bed,
            resources=resources,
    }
}
