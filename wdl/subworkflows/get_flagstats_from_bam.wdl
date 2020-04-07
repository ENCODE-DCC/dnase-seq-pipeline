version 1.0


import "../tasks/samtools.wdl"


workflow get_flagstats_from_bam {
    input {
        File bam
        Resources resources
    }

    call samtools.flagstats {
        input:
            bam=bam,
            resources=resources,
    }

    output {
        File bam_flagstats = flagstats.bam_flagstats
    }
}
