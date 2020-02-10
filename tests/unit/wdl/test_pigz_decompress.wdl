version 1.0


import "../../../wdl/tasks/pigz.wdl"


workflow test_decompress {
    input {
        Boolean compress
        File input_file
        Resources resources
        String output_filename
    }

    call pigz.pigz{
        input:
            compress=compress,
            input_file=input_file,
            output_filename=output_filename,
            resources=resources,
    }
}
