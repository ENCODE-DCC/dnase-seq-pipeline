version 1.0


import "../tasks/ucsc.wdl"


workflow make_big_bed_from_broad_peak_bed {
    input {
        File broad_peak_bed
        File chrom_sizes
        File auto_sql
        BedToBigBedParams params = object {
            type: "bed6+3"
        }
        Resources resources
    }

    call ucsc.bed_to_big_bed {
        input:
             bed=broad_peak_bed,
             chrom_sizes=chrom_sizes,
             auto_sql=auto_sql,
             params=params,
             resources=resources,
    }

    output {
        File big_bed = bed_to_big_bed.big_bed
    }
}
