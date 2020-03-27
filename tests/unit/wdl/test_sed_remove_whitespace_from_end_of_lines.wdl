version 1.0


import "../../../wdl/tasks/sed.wdl"


workflow test_sed_remove_whitespace_from_end_of_lines {
    input {
        File input_file
        Resources resources
    }

    call sed.remove_whitespace_from_end_of_lines {
        input:
            input_file=input_file,
            resources=resources,
    }
}
