version 1.0


import "../structs/resources.wdl"
import "../structs/ucsc.wdl"


task bed_to_big_bed {
    input {
        File bed
        File chrom_sizes
        BedToBigBedParams params
        Resources resources
    }

    String out = basename(bed, ".bed") + ".bb"

    command {
        bedToBigBed \
            ~{"-type=" + params.type} \
            ~{"-as=" + params.auto_sql} \
            ~{bed} \
            ~{chrom_sizes} \
            ~{out}
    }

    output {
        File big_bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
