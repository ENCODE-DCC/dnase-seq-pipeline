version 1.0


import "../structs/bwa.wdl"
import "../structs/fastq.wdl"
import "../structs/resources.wdl"


task index {
    input {
        File fasta
        Resources resources
    }

    String prefix = basename(fasta)

    command {
        ln ~{fasta} .
        bwa index ~{prefix}
    }

    output {
        BwaIndex bwa_index = {
            "fasta": prefix,
            "amb": "~{prefix}.amb",
            "ann": "~{prefix}.ann",
            "bwt": "~{prefix}.bwt",
            "pac": "~{prefix}.pac",
            "sa": "~{prefix}.sa"
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task aln {
    input {
        File fastq
        BwaIndex bwa_index
        BwaAlnParams params
        Resources resources
        String out = "out.sai"
    }
    
    command {
        bwa aln \
        ~{true="-Y" false="" params.filter_casava} \
        ~{"-n " + params.probability_missing} \
        ~{"-l " + params.seed_length} \
        ~{"-t " + params.threads} \
        ~{bwa_index.fasta} \
        ~{fastq} \
        > ~{out}
    }

    output {
        File sai = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task sampe {
    input {
        FastqPair fastqs
        SaiPair sais
        BwaIndex bwa_index
        BwaSampeParams params
        Resources resources
        String out = "out.sam"
    }

    command {
        bwa sampe \
        ~{"-a " + params.max_insert_size}
        ~{"-n " + params.max_paired_hits}
        ~{bwa_index.fasta} \
        ~{sais.S1} \
        ~{sais.S2} \
        ~{fastqs.R1} \
        ~{fastqs.R2} \
        > ~{out}
    }

    output {
        File sam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
