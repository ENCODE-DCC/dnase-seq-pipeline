version 1.0


import "../tasks/pigz.wdl"


workflow make_gz_bed_from_bed {
    input {
        File bed
        Resources resources
    }

    String output_filename = basename(bed) + ".gz"

    call pigz.pigz as compress {
        input:
            input_file=bed,
            params={"noname": true},
            output_filename=output_filename,
            resources=resources,
    }

    output {
        File gz_bed = compress.out
    }
}
