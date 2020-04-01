version 1.0


import "../tasks/stampipes.wdl"


workflow get_chrombuckets {
    input {
        File fai
        Int bin_size = 20
        Int window_size = 75
        Resources resources
        String genome_name
    }

    call stampipes.chrom_buckets {
        input:
            bin_size=bin_size,
            fai=fai,
            genome_name=genome_name,
            resources=resources,
            window_size=window_size,
    }

    output {
        File chrombuckets = chrom_buckets.chrombuckets
    }
}
