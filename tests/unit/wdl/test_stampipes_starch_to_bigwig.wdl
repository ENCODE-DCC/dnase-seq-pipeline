version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_starch_to_bigwig {
    input {
        File starch
        File chrom_sizes
        Int? bin_size
        Resources resources
    }

    call stampipes.starch_to_bigwig {
        input:
            starch=starch,
            chrom_sizes=chrom_sizes,
            bin_size=bin_size,
            resources=resources,
    }
}
