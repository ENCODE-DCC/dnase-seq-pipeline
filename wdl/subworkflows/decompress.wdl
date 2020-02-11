version 1.0


import "../tasks/pigz.wdl"


workflow decompress {
    input {
        Boolean compress = false 
        File input_file
        String output_filename
        Resources resources
    }

    call pigz.pigz {
        input:
            compress=compress,
            input_file=input_file,
            output_filename=output_filename,
            resources=resources
    }
    output {
        File out = pigz.out
    }
}
