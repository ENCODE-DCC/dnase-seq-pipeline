version 1.0


import "../../../wdl/tasks/bedops.wdl"


workflow test_bedops_sort_bed {
    input {
        File unsorted_bed
        BedopsSortBedParams params
        Resources resources
    }

    call bedops.sort_bed {
        input:
            unsorted_bed=unsorted_bed,
            params=params,
            resources=resources,
    }
}
