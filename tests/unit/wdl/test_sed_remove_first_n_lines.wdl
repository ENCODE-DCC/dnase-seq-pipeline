version 1.0


import "../../../wdl/tasks/sed.wdl"


workflow test_sed_remove_first_n_lines {
    input {
        File input_file
        Int number_of_lines
        Resources resources
    }

    call sed.remove_first_n_lines {
        input:
            input_file=input_file,
            number_of_lines=number_of_lines,
            resources=resources,
    }
}
