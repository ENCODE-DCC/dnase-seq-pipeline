version 1.0


import "../../../wdl/subworkflows/merge_name_sorted_bams.wdl" as name_sorted_bams


workflow test_merge_name_sorted_bams {
    call name_sorted_bams.merge_name_sorted_bams
}
