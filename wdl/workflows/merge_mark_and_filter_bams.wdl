version 1.0


import "../../wdl/workflows/mixed/merge.wdl" as name_sorted_bams
import "../../wdl/workflows/mixed/mark.wdl" as merged_bam
import "../../wdl/workflows/mixed/filter.wdl" as flagged_and_marked_bam


workflow merge_mark_and_filter_bams {
    input {
        Array[File] name_sorted_bams
        String machine_size_merge = "medium"
        String machine_size_mark = "medium"
        String machine_size_filter = "medium"
    }

    call name_sorted_bams.merge {
        input:
            name_sorted_bams=name_sorted_bams,
            machine_size=machine_size_merge,
    }

    call merged_bam.mark {
        input:
            merged_bam=merge.merged_bam,
            machine_size=machine_size_mark,
    }

    call flagged_and_marked_bam.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam,
            machine_size=machine_size_filter,
    }

    output {
        File unfiltered_bam = merge.merged_bam
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File duplication_metrics = mark.duplication_metrics
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
    }
}
