version 1.0


import "../../../wdl/tasks/hotspot2.wdl"


workflow test_hotspot2_extract_center_sites {
    input {
        File chrom_sizes
        File mappable_regions_bed
        Int neighborhood_size
        Resources resources
    }

    call hotspot2.extract_center_sites {
        input:
            chrom_sizes=chrom_sizes,
            mappable_regions_bed=mappable_regions_bed,
            neighborhood_size=neighborhood_size,
            resources=resources,
    }
}
