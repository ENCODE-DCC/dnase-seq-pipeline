version 1.0


import "../structs/hotspot1.wdl"
import "../structs/resources.wdl"


task runhotspot {
    input {
        File subsampled_bam
        HotSpot1Index index
        HotSpot1Params params
        Resources resources
    }

    String prefix = basename(subsampled_bam, ".bam")

    command {
        ln ~{index.chrom_info} .
        ln ~{index.mappable_regions} .
        runhotspot.bash \
            $HOTSPOT_DIRECTORY \
            $PWD \
            ~{subsampled_bam} \
            ~{params.genome_name} \
            ~{params.read_length} \
            DNaseI
    }

    output {
        File spot_score = "~{prefix}.spot.out"
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
