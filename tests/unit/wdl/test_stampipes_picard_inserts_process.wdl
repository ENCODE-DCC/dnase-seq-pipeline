version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_picard_inserts_process {
    input {
        File histogram
        Resources resources
    }

    call stampipes.picard_inserts_process {
        input:
            histogram=histogram,
            resources=resources,
    }
}
