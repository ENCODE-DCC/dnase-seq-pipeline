version 1.0


import "../../wdl/workflows/se/concatenate.wdl" as raw_fastqs
import "../../wdl/workflows/se/trim.wdl" as concatenated_fastq
import "../../wdl/workflows/se/align.wdl" as trimmed_fastq


workflow concatenate_trim_and_align_se_fastqs {
    input {
        Array[File] raw_fastqs
        String machine_size_trim = "medium"
        String machine_size_align = "medium"
    }

    call raw_fastqs.concatenate {
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

    call name_sorted_bam.mark {
        input:
            name_sorted_bam=align.name_sorted_bam,
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
