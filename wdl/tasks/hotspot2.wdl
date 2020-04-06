version 1.0


import "../structs/hotspot2.wdl"
import "../structs/resources.wdl"


task hotspot2 {
    input {
        File nuclear_bam
        HotSpot2Reference reference
        HotSpot2Params params
        Resources resources
    }

    Float fdr = params.hotspot_threshold
    String prefix = basename(nuclear_bam, ".bam") + "." + fdr

    command {
        ln ~{nuclear_bam} ~{prefix}
        hotspot2.sh \
            -c ~{reference.chrom_sizes} \
            -C ~{reference.center_sites} \
            -M ~{reference.mappable_regions} \
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


task extract_center_sites {
    input {
        File chrom_sizes
        File mappable_regions
        Int neighborhood_size
        Resources resources
        String out = "center_sites.starch"
    }

    command {
        $(which extractCenterSites.sh) \
            -c ~{chrom_sizes} \
            -M ~{mappable_regions} \
            -o ~{out} \
            -n ~{neighborhood_size}
    }

    output {
        File center_sites_starch = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
