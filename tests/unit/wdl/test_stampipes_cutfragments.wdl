version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_cutfragments {
    input {
        File bed
        Resources resources
    }

    call stampipes.cutfragments {
        input:
            bed=bed,
            resources=resources,
    }
}
