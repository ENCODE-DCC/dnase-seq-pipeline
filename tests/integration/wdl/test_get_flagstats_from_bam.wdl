version 1.0


import "../../../wdl/subworkflows/get_flagstats_from_bam.wdl"


workflow test_get_flagstats_from_bam {
    call get_flagstats_from_bam.get_flagstats_from_bam
}
