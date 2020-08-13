version 1.0


import "../tasks/pigz.wdl"


workflow make_txt_from_txt_gz {
    input {
        File txt_gz
        Resources resources
    }

    String output_filename = basename(txt_gz, ".gz")

    call pigz.pigz as decompress {
        input:
            input_file=txt_gz,
            params={"decompress": true},
            output_filename=output_filename,
            resources=resources,
    }

    output {
        File txt = decompress.out
    }
}
