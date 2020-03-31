version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_chrom_buckets {
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
}
