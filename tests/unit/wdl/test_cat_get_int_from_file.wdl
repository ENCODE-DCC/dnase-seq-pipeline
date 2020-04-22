version 1.0


import "../../../wdl/tasks/cat.wdl"


workflow test_cat_get_int_from_file {
    input {
        File in
        Resources resources
    }

    call cat.get_int_from_file {
        input:
            in=in,
            resources=resources,
    }
}
