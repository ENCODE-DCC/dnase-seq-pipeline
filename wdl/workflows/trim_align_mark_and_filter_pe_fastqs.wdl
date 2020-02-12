version 1.0


import "pe/trim.wdl"
import "pe/align.wdl"
import "pe/mark.wdl"
import "pe/filter.wdl"


workflow trim_align_mark_and_filter_pe_fastqs {
    input {
        BwaIndex bwa_index
        FastqPair raw_fastqs
        File adapters
        File nuclear_chroms
        IndexedFasta indexed_fasta
        String machine_size_trim = 'medium'
        String machine_size_align = 'large'
        String machine_size_mark = 'medium2x'
        String machine_size_filter = 'medium'
    }

    call trim.trim {
        input:
            raw_fastqs=raw_fastqs,
            machine_size=machine_size_trim,
    }

    call align.align {
        input:
            bwa_index=bwa_index,
            indexed_fasta=indexed_fasta,
            trimmed_fastqs=trim.trimmed_fastqs,
            machine_size=machine_size_align,
    }

    call mark.mark {
        input:
            sorted_bam=align.sorted_bam,
            nuclear_chroms=nuclear_chroms,
            machine_size=machine_size_mark,
    }

    call filter.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam,
            machine_size=machine_size_filter,
    }

    output {
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
        File trimstats = trim.trimstats
        File duplicate_metrics = mark.duplication_metrics
    }
}
