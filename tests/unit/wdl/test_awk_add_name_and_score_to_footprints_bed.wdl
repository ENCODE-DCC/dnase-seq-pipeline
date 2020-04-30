version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_add_name_and_score_to_footprints_bed {
    input {
        File bed
        Float threshold
        Resources resources
    }

    call awk.add_name_and_score_to_footprints_bed {
        input:
            bed=bed,
            threshold=threshold,
            resources=resources,
    }
}
