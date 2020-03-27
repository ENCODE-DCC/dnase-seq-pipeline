version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_merge_adjacent_bed {
    input {
        File bed
        Resources resources
    }

    call awk.merge_adjacent_bed {
        input:
            bed=bed,
            resources=resources,
    }
}
