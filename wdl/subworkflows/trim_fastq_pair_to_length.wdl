version 1.0


import "trim_fastq_to_length.wdl"
import "../structs/fastq.wdl"


workflow trim_fastq_pair_to_length {
    input {
        FastqPair fastqs_to_trim
        Int trim_length
        Resources resources_trim_pair
    }
    
    scatter (fastq in [fastqs_to_trim.R1, fastqs_to_trim.R2]) {
        call trim_fastq_to_length.trim_fastq_to_length as trim {
            input:
                fastq=fastq,
                trim_length=trim_length,
                resources=resources_trim_pair,
        }
    }

    output {
        FastqPair fastqs_out = {
            "R1": trim.trimmed[0],
            "R2": trim.trimmed[1]
        }
    }
}
