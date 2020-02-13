version 1.0


import "trim_fastq_to_length.wdl"
import "../structs/fastq.wdl"


workflow trim_fastq_pair_to_length {
    input {
        FastqPair fastqs
        Int trim_length
        Resources resources
    }
    
    scatter (fastq in [fastqs.R1, fastqs.R2]) {
        call trim_fastq_to_length.trim_fastq_to_length as trim {
            input:
                fastq=fastq,
                trim_length=trim_length,
                resources=resources,
        }
    }

    output {
        FastqPair trimmed_fastqs = {
            "R1": trim.trimmed[0],
            "R2": trim.trimmed[1]
        }
    }
}
