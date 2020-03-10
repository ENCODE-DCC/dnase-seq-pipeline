version 1.0


import "../tasks/awk.wdl"
import "../tasks/pigz.wdl"


workflow trim_fastq_to_length {
    input {
        File fastq
        Int trim_length
        Resources resources
    }

    String output_filename = "trimmed_to_length_" + basename(fastq)

    call pigz.pigz as decompress {
        input:
            input_file=fastq,
            params={"decompress": true},
            resources=resources,
    }

    call awk.trim_fastq_reads_to_length {
        input:
            input_file=decompress.out,
            trim_length=trim_length,
            resources=resources,
    }

    call pigz.pigz as compress {
        input:
            input_file=trim_to_length.trimmed,
            params={"noname": true},
            output_filename=output_filename,
            resources=resources,
    }

    output {
        File trimmed = compress.out
    }
}
