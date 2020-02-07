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
    }

    call awk.trim_to_length {
    }

    call compression.compress {
    }

    output {
        File trimmed = compress.compressed
    }
}
