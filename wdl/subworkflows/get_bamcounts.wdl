version 1.0


import "../tasks/bamcounts.wdl"


workflow get_bamcounts {
    input {
        File bam
        Resources resources
    }

    call bamcounts.bamcounts {
        input:
            bam=bam,
            resources=resources,
    }

    output {
        File counts = bamcounts.counts
    }
}
