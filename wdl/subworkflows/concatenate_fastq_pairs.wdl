version 1.0


import "concatenate_fastqs.wdl" as cat
import "../structs/fastq.wdl"


workflow concatenate_fastq_pairs {
    input {
        Array[FastqPair] fastqs
        Resources resources
    }

    scatter(fastq in fastqs) {
        File R1s = fastq.R1
        File R2s = fastq.R2
    }

    call cat.concatenate_fastqs as concatenate_R1s {
        input:
            fastqs=R1s,
            resources=resources,
            out="concatenated.R1.fastq.gz",
    }

    call cat.concatenate_fastqs as concatenate_R2s {
        input:
            fastqs=R2s,
            resources=resources,
            out="concatenated.R2.fastq.gz",
    }

    output {
        FastqPair concatenated_fastqs = {
            "R1": concatenate_R1s.concatenated_fastq,
            "R2": concatenate_R2s.concatenated_fastq
        }
    }
}
