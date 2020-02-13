version 1.0


import "../../wdl/workflows/pe/trim.wdl" as raw_fastqs
import "../../wdl/workflows/pe/align.wdl" as trimmed_fastqs
import "../../wdl/workflows/pe/mark.wdl" as sorted_bam
import "../../wdl/workflows/pe/filter.wdl" as flagged_and_marked_bam


workflow trim_align_mark_and_filter_pe_fastqs {
    input {
        FastqPair raw_fastqs
        String machine_size_trim = "medium"
        String machine_size_align = "large"
        String machine_size_mark = "medium2x"
        String machine_size_filter = "medium"
    }

    call raw_fastqs.trim {
        input:
            raw_fastqs=raw_fastqs,
            machine_size=machine_size_trim,
    }

    call trimmed_fastqs.align {
        input:
            trimmed_fastqs=trim.trimmed_fastqs,
            machine_size=machine_size_align,
    }

    call sorted_bam.mark {
        input:
            sorted_bam=align.sorted_bam,
            machine_size=machine_size_mark,
    }

    call flagged_and_marked_bam.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam,
            machine_size=machine_size_filter,
    }

    output {
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
        File trimstats = trim.trimstats
        File duplication_metrics = mark.duplication_metrics
    }
}
