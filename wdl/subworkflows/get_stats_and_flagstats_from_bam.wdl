version 1.0


import "get_stats_from_bam.wdl" as bam_for_stats
import "get_flagstats_from_bam.wdl" as bam_for_flagstats


workflow get_stats_and_flagstats_from_bam {
    input {
        File bam
        Resources resources
    }

    call bam_for_stats.get_stats_from_bam {
        input:
            bam=bam,
            resources=resources,
    }

    call bam_for_flagstats.get_flagstats_from_bam {
        input:
            bam=bam,
            resources=resources,
    }

    output {
        File stats = get_stats_from_bam.bam_stats
        File flagstats = get_flagstats_from_bam.bam_flagstats
    }
}
