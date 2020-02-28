version 1.0


import "../tasks/stampipes.wdl"


workflow get_bamcounts {
    input {
        File bam
        Resources resources
    }

    call stampipes.bamcounts {
        input:
            bam=bam,
            resources=resources,
    }

    output {
        File counts = bamcounts.counts
    }
}
