version 1.0


import "../../../wdl/subworkflows/mark_duplicates_in_bam_and_get_duplication_metrics.wdl" as mark


workflow test_mark_duplicates_in_bam_and_get_duplication_metrics {
    call mark.mark_duplicates_in_bam_and_get_duplication_metrics
}
