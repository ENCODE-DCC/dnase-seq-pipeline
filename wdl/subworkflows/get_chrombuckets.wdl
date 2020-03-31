version 1.0


import "../tasks/stampipes.wdl"


workflow get_chrombuckets {
    input {
        File fai
        Resources resources
        String genome_name
    }

    call stampipes.chrom_buckets {
        input:
            fai=fai,
            genome_name=genome_name,
            resources=resources,
    }

    output {
        File chrombuckets = chrom_buckets.chrombuckets
    }
}
