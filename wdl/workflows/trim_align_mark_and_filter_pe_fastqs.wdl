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
        Machines compute = read_json("runtimes.json")
        
        String preprocess_size = 'small'
        String align_size = 'medium'
        String mark_size = 'medium'
        String filter_size = 'small'
    }

    call preprocess.preprocess {
        input:
            raw_fastqs=raw_fastqs,
            runtimes=compute.runtimes,
            size=preprocess_size,
    }

    call align.align {
        input:
            bwa_index=bwa_index,
            indexed_fasta=indexed_fasta,
            preprocessed_fastqs=preprocess.trimmed_fastqs,
            runtimes=compute.runtimes,
            size=align_size,
    }

    call mark.mark {
        input:
            sorted_bam=align.sorted_bam,
            nuclear_chroms=nuclear_chroms,
            runtimes=compute.runtimes,
            size=align_size,
    }

    call filter.filter {
        input:
            flagged_and_marked_bam=mark.flagged_and_marked_bam,
            runtimes=compute.runtimes,
            size=align_size,
    }

    output {
        File flagged_and_marked_bam = mark.flagged_and_marked_bam
        File filtered_bam = filter.filtered
        File nuclear_bam = filter.nuclear
        File trimstats = preprocess.trimstats
        File duplicate_metrics = mark.duplication_metrics
    }
}
