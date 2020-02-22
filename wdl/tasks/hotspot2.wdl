version 1.0


import "../structs/hotspot2.wdl"
import "../structs/resources.wdl"


task hotspot2 {
    input {
        File nuclear_bam
        HotSpot2Index index
        HotSpot2Params params
        Resources resources
    }

    Float fdr = params.hotspot_threshold
    String prefix = basename(nuclear_bam, ".bam") + "." + fdr

    command {
        ln ~{nuclear_bam} ~{prefix}
        hotspot2.sh \
            -c ~{index.chrom_sizes} \
            -C ~{index.center_sites} \
            -M ~{index.mappable_regions} \
            ~{"-f " + params.hotspot_threshold} \
            ~{"-F " + params.site_call_threshold} \
            ~{"-p " + params.peaks_definition} \
            ~{prefix} \
            .
    }

    output {
        HotSpot2Peaks peaks = {
            "allcalls": "~{prefix}.allcalls.starch",
            "cleavage": "~{prefix}.cleavage.total",
            "cutcounts": "~{prefix}.cutcounts.starch",
            "density_bed": "~{prefix}.density.starch",
            "density_bw": "~{prefix}.density.bw",
            "fragments": "~{prefix}.fragments.sorted.starch",
            "hotspots": "~{prefix}.hotspots.fdr~{fdr}.starch",
            "peaks": "~{prefix}.peaks.starch",
            "narrowpeaks": "~{prefix}.peaks.narrowpeaks.starch",
            "spot_score": "~{prefix}.SPOT.txt"
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
