version 1.0


import "../structs/fastq.wdl"
import "../structs/resources.wdl"


task trim_adapters {
    input {
        FastqPair fastqs
        File adapters
        Resources resources
        String adapter1 = "P5"
        String adapter2 = "P7"
        String read1_out_filename = "trim.R1.fastq.gz"
        String read2_out_filename = "trim.R2.fastq.gz"
        String trimstats_out_filename = "trimstats.txt"
    }

    command {
        trim-adapters-illumina \
            -f ~{adapters} \
            -1 ~{adapter1} \
            -2 ~{adapter2} \
            --threads=~{resources.cpu} \
            ~{fastqs.R1} \
            ~{fastqs.R2} \
            ~{read1_out_filename} \
            ~{read2_out_filename} \
            &> ~{trimstats_out_filename}
    }

    output {
        FastqPair trimmed_fastqs = {
            "R1": read1_out_filename,
            "R2": read2_out_filename
        }
        File trimstats = trimstats_out_filename
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
