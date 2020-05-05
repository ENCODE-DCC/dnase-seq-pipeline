version 1.0


import "../structs/bedops.wdl"
import "../structs/resources.wdl"


task unstarch {
    input {
        File starch
        BedopsUnstarchParams params = {}
        Resources resources
        String out_path = "out.bed"
    }

    command {
        unstarch \
            ~{true="--elements" false="" params.elements} \
            ~{starch} \
            > ~{out}
    }

    output {
        File out = out_path
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task starch {
    input {
        File sorted_bed
        Resources resources
        String out = "out.starch"
    }

    command {
        starch \
            ~{sorted_bed} \
            > ~{out}
    }

    output {
        File starch = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task sort_bed {
    input {
        File unsorted_bed
        BedopsSortBedParams params
        Resources resources
        String out = "sorted.bed"
    }

    command {
        sort-bed \
            ~{"--max-mem " + params.max_memory} \
            ~{unsorted_bed} \
            > ~{out}
    }

    output {
        File sorted_bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task bam2bed {
    input {
        File bam
        BedopsBam2BedParams params
        Resources resources
        String out = "out.bed"
    }

    command {
        bam2bed \
            ~{true="--do-not-sort" false="" params.do_not_sort} \
            < ~{bam} \
            > ~{out}
    }

    output {
        File bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task bedmap {
    input {
        File sorted_reference_bed_or_starch
        File sorted_map_bed_or_starch
        BedopsBedMapParams params
        Resources resources
        String out = "mapped.bed"
    }

    command {
        bedmap \
            ~{true="--count" false="" params.count} \
            ~{true="--echo" false="" params.echo} \
            ~{true="--faster" false="" params.faster} \
            ~{"--delim " + params.delimiter} \
            ~{sorted_reference_bed_or_starch} \
            ~{sorted_map_bed_or_starch} \
            > ~{out}
    }

    output {
        File mapped_bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task merge {
    input {
        File sorted_bed
        Resources resources
        String out = basename(sorted_bed, ".bed") + "_merged.bed"
    }

    command {
        bedops \
            --merge \
            ~{sorted_bed} \
            > ~{out}
    }

    output {
        File merged_bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
