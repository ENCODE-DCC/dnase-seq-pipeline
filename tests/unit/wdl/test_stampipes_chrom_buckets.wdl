version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_chrom_buckets {
    input {
        File fai
        Int bin_size
        Int window_size
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
}
