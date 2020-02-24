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
