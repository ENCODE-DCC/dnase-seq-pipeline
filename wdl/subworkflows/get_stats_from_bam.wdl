version 1.0


import "../tasks/samtools.wdl"


workflow get_stats_from_bam {
    input {
        File bam
        Resources resources
    }

    call samtools.stats {
        input:
            bam=bam,
            resources=resources,
    }

    output {
        File bam_stats = stats.bam_stats
    }
}
