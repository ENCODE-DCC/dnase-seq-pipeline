version 1.0


import "../tasks/awk.wdl"
import "../tasks/compression.wdl"


workflow trim_fastq_to_length {
    input {
        File fastq
        Int trim_length
        Resources resources
        String output_filename
    }

    call compression.decompress {
        input:
            input_file=fastq,
            resources=resources,
    }

    call awk.trim_to_length {
        input:
            input_file=decompress.decompressed,
            trim_length=trim_length,
            resources=resources,
    }

    call compression.compress {
        input:
            input_file=trim_to_length.trimmed,
            output_filename=output_filename,
            resources=resources,
    }

    output {
        File trimmed = compress.compressed
    }
}
