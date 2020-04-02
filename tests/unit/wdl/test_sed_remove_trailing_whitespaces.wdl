version 1.0


import "../../../wdl/tasks/sed.wdl"


workflow test_sed_remove_trailing_whitespaces {
    input {
        File input_file
        Resources resources
    }

    call sed.remove_trailing_whitespaces {
        input:
            input_file=input_file,
            resources=resources,
    }
}
