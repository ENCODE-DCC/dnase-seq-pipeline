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


task starch_to_bigwig {
    input {
        File starch
        File chrom_sizes
        Int? bin_size
        Resources resources
        String out = basename(starch, "starch") + ".bw"
    }

    command {
        starch_to_bigwig.bash \
            ~{starch} \
            ~{out} \
            ~{chrom_sizes} \
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
