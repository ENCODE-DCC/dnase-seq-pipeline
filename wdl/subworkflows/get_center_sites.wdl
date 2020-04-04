version 1.0


import "../../wdl/tasks/hotspot2.wdl"


workflow get_center_sites {
    input {
        File chrom_sizes
        File mappable_regions
        Int neighborhood_size = 100
        Resources resources
    }

    String output_prefix = basename(mappable_regions, ".mappable_only.bed")
    String center_sites_output = output_prefix + ".center_sites.n" + neighborhood_size + ".starch"

    call hotspot2.extract_center_sites {
        input:
            chrom_sizes=chrom_sizes,
            mappable_regions=mappable_regions,
            neighborhood_size=neighborhood_size,
            out=center_sites_output,
            resources=resources,
    }

    output {
        File center_sites_starch = extract_center_sites.center_sites_starch
    }
}
