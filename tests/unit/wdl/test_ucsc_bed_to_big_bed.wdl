version 1.0


import "../../../wdl/tasks/ucsc.wdl"


workflow test_ucsc_bed_to_big_bed {
    input {
        File bed
        File chrom_sizes
        File? auto_sql
        BedToBigBedParams params
        Resources resources
    }

    call ucsc.bed_to_big_bed {
        input:
            bed=bed,
            chrom_sizes=chrom_sizes,
            auto_sql=auto_sql,
            params=params,
            resources=resources,
    }
}
