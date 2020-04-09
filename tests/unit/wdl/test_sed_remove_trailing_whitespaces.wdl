version 1.0


import "../../../wdl/tasks/sed.wdl"


workflow test_sed_remove_trailing_whitespaces {
    input {
        File in
        Resources resources
    }

    call sed.remove_trailing_whitespaces {
        input:
            in=in,
            resources=resources,
    }
}
