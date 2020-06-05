version 1.0


import "../structs/fastq.wdl"
import "../structs/resources.wdl"
import "../structs/cutadapt.wdl"


task cutadapt {
    input {
        FastqPair fastqs
        Adapters adapters
        Resources resources
        String read1_out_filename = "trim.R1.fastq.gz"
        String read2_out_filename = "trim.R2.fastq.gz"
        String trimstats_out_filename = "trimstats.txt"
    }

    command {
        cutadapt \
            ~{"-a " + adapters.sequence1} \
            ~{"-A " + adapters.sequence2} \
            --cores=~{resources.cpu} \
            --pair-filter both \
            ~{"--output " + read1_out_filename} \
            ~{"--paired-output " + read2_out_filename} \
            ~{fastqs.R1} \
            ~{fastqs.R2} \
            > ~{trimstats_out_filename}
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
