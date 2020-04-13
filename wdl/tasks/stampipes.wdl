version 1.0


import "../structs/resources.wdl"


task filter_reads {
    input {
        File bam
        File nuclear_chroms
        Resources resources
        String out = "flagged.bam"
    }

    command {
        python3 $(which filter_reads.py) \
            ~{bam} \
            ~{out} \
            ~{nuclear_chroms}
    }

    output {
        File flagged_bam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task bamcounts  {
    input {
        File bam
        Resources resources
        String out = "tagcounts.txt"
    }

    command {
        python3 $(which bamcounts.py) \
            ~{bam} \
            ~{out}
    }

    output {
        File counts = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task info {
    input {
         File hotspots
         File spot_score
         String spot_type
         Resources resources
         String out = basename(hotspots, ".starch") + "." + spot_type + ".info"
    }

    command {
        info.sh \
            ~{hotspots} \
            ~{spot_type} \
            ~{spot_score} \
            > ~{out}
    }

    output {
        File hotspot_info = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task random_sample {
    input {
        File bam
        Int sample_number
        Resources resources
        String out = "subsample.bam"
    }

    command {
        random_sample.sh \
            ~{bam} \
            ~{out} \
            ~{sample_number}
    }

    output {
        File subsampled_bam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task random_sample_read1 {
    input {
        File bam
        Int sample_number
        Resources resources
        String out = "subsample.bam"
    }

    command {
        random_sample_read1.sh \
            ~{bam} \
            ~{out} \
            ~{sample_number}
    }

    output {
        File subsampled_bam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task starch_to_bigwig {
    input {
        File starch
        File fai
        Int? bin_size
        Resources resources
        String out = basename(starch, ".starch") + ".bw"
    }

    command {
        starch_to_bigwig.bash \
            ~{starch} \
            ~{out} \
            ~{fai} \
            ~{bin_size}
    }

    output {
        File bigwig = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task cutfragments {
    input {
        File bed
        Resources resources
        String cuts_path = "cuts.bed"
        String fragments_path = "fragments.bed"
    }

    command {
        awk \
            -v cutfile=~{cuts_path} \
            -v fragmentfile=~{fragments_path} \
            -f cutfragments.awk \
            ~{bed}
    }

    output {
        File cuts_bed = cuts_path
        File fragments_bed = fragments_path
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task chrom_buckets {
    input {
        File fai
        Int bin_size
        Int window_size
        Resources resources
        String genome_name
    }

    command {
        make all \
            -f $(which chrombuckets.mk) \
            FAI=~{fai} \
            GENOME=~{genome_name} \
            BUCKETS_DIR=. \
            BINI=~{bin_size} \
            WIN=~{window_size}
    }

    output {
        File chrombuckets = "chrom-buckets." + genome_name + "." + window_size + "_" + bin_size + ".bed.starch"
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task picard_inserts_process {
    input {
        File histogram
        Resources resources
        String out = "CollectInsertSizeMetrics.picard.info"
    }

    command {
        python3 $(which picard_inserts_process.py) \
            ~{histogram} \
            > ~{out}
    }

    output {
        File insert_size_metrics_info = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task mark_dups {
    input {
        File bam
        Resources resources
        String out = "dups.hist"
    }

    command {
        python3 $(which mark_dups.py) \
            -i ~{bam} \
            -o /dev/null \
            --hist ~{out}
    }

    output {
        File histogram = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task get_preseq_targets {
    input {
        File preseq
        Resources resources
        String out = "preseq_targets.txt"
    }

    command {
        preseq_targets.sh \
            ~{preseq} \
            ~{out}
    }

    output {
        File preseq_targets = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
