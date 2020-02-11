version 1.0


import "pe/preprocess.wdl"
import "pe/align.wdl"
import "pe/mark.wdl"
import "pe/filter.wdl"


workflow trim_align_mark_and_filter_pe_fastqs {
    input {
        FastqPair raw_fastqs
        BwaIndex bwa_index
        IndexedFasta indexed_fasta
        File adapters
        File nuclear_chroms
        
        Resources trim_adapter_resources
        Resources align_resources
        Resources mark_resources
        Resources filter_resources
    }

    call preprocess.preprocess {
        input:
            raw_fastqs=raw_fastqs,
            trim_adapter_resources=trim_adapter_resources,
    }

    call align.align {
        input:
            bwa_index=bwa_index,
            indexed_fasta=indexed_fasta,
            preprocessed_fastqs=preprocess.trimmed_fastqs,
            align_resources=align_resources,
    }

    call mark.mark {
        input:
            sorted_bam=align.sorted_bam,
            mark_resources=mark_resources,
            nuclear_chroms=nuclear_chroms,
    }

    call filter.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam,
            filter_resources=filter_resources,
    }

    output {
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
        File trimstats = preprocess.trimstats
        File duplicate_metrics = mark.duplication_metrics
    }
}
