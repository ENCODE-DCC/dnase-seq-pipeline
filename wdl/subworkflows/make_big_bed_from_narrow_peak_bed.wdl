version 1.0


import "../tasks/ucsc.wdl"


workflow make_big_bed_from_narrow_peak_bed {
    input {
        File narrow_peak_bed
        File chrom_sizes
        File auto_sql
        BedToBigBedParams params = object {
            type: "bed6+4"
        }
        Resources resources
    }

    call ucsc.bed_to_big_bed {
        input:
             bed=narrow_peak_bed,
             chrom_sizes=chrom_sizes,
             auto_sql=auto_sql,
             params=params,
             resources=resources,
    }

    output {
        File big_bed = bed_to_big_bed.big_bed
    }
}
