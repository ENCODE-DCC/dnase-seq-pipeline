version 1.0


import "../../../wdl/tasks/compression.wdl"


workflow test_compress {
    input {
        File input_file
        Resources resources
        String output_filename
    }

    call compression.compress {
        input: 
            input_file=input_file,
            output_filename=output_filename,
            resources=resources,
    }
}