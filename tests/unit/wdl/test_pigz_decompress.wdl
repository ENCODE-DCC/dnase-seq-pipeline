version 1.0


import "../../../wdl/tasks/pigz.wdl"


workflow test_decompress {
    input {
        File input_file
        PigzParams params
        Resources resources
        String output_filename
    }

    call pigz.pigz{
        input:
            input_file=input_file,
            output_filename=output_filename,
            params=params,
            resources=resources,
    }
}
