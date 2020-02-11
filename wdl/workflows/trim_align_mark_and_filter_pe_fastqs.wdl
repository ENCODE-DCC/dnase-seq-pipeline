version 1.0


import "pe/preprocess.wdl"
import "pe/align.wdl"
import "pe/mark.wdl"
import "pe/filter.wdl"


workflow trim_align_mark_and_filter_pe_fastqs {
    input {
        FastqPair raw_fastqs
    }

    call preprocess.preprocess {
        input:
            fastq=raw_fastqs
    }

    call align.align {
        input:
            preprocessed_fastqs=preprocess.trimmed_fastqs
    }

    call mark.mark {
        input:
            sorted_bam=align.sorted_bam
    }

    call filter.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam
    }

    output {
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
        File trimstats = preprocess.trimstats
        File duplicate_metrics = mark.duplicate_metrics
    }
}
