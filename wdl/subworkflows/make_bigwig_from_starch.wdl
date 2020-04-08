version 1.0


import "../tasks/stampipes.wdl"


workflow make_bigwig_from_starch {
    input {
        File starch
        File chrom_sizes
        Int bin_size = 20
        Resources resources
    }

    call stampipes.starch_to_bigwig {
        input:
             starch=starch,
             chrom_sizes=chrom_sizes,
             resources=resources,
    }

    output {
        File bigwig = starch_to_bigwig.bigwig
    }
}
