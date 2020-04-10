version 1.0


import "../../../wdl/tasks/ucsc.wdl"


workflow test_ucsc_bed_to_big_bed {
    input {
        File bed
        File chrom_sizes
        BedToBigBedParams params
        Resources resources
    }

    call ucsc.bed_to_big_bed {
        input:
            bed=bed,
            chrom_sizes=chrom_sizes,
            params=params,
            resources=resources,
    }
}
