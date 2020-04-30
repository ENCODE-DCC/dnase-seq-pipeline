version 1.0


import "../tasks/ucsc.wdl"


workflow make_big_bed_from_three_plus_two_bed {
    input {
        File three_plus_two_bed
        File chrom_sizes
        BedToBigBedParams params = object {
            type: "bed3+2"
        }
        Resources resources
    }

    call ucsc.bed_to_big_bed {
        input:
             bed=three_plus_two_bed,
             chrom_sizes=chrom_sizes,
             params=params,
             resources=resources,
    }

    output {
        File big_bed = bed_to_big_bed.big_bed
    }
}
