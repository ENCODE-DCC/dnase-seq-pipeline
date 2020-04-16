version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/workflows/mixed/merge.wdl" as name_sorted_bams
import "../../wdl/workflows/mixed/mark.wdl" as merged_bam
import "../../wdl/workflows/mixed/filter.wdl" as flagged_and_marked_bam


workflow merge_mark_and_filter_bams {
    input {
        Array[File] name_sorted_bams
        References references
        MachineSizes machine_sizes
    }

    call name_sorted_bams.merge {
        input:
            name_sorted_bams=name_sorted_bams,
            machine_size=machine_sizes.merge,
    }

    call merged_bam.mark {
        input:
            merged_bam=merge.merged_bam,
            nuclear_chroms=references.nuclear_chroms,
            machine_size=machine_sizes.mark,
    }

    call flagged_and_marked_bam.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam,
            machine_size=machine_sizes.filter,
    }

    output {
        File unfiltered_bam = merge.merged_bam
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File duplication_metrics = mark.duplication_metrics
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
    }
}
