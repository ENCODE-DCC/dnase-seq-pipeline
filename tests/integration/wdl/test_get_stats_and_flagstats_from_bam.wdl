version 1.0


import "../../../wdl/subworkflows/get_stats_and_flagstats_from_bam.wdl"


workflow test_get_stats_and_flagstats_from_bam {
    call get_stats_and_flagstats_from_bam.get_stats_and_flagstats_from_bam
}
