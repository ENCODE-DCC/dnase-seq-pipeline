version 1.0


import "../../../wdl/subworkflows/filter_bam_reads_with_nonnuclear_flag.wdl" as flagged_bam


workflow test_filter_bam_reads_with_nonnuclear_flag {
    call flagged_bam.filter_bam_reads_with_nonnuclear_flag
}
