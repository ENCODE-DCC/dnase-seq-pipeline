version 1.0


import "../../wdl/workflows/pe/concatenate.wdl" as raw_fastqs
import "../../wdl/workflows/pe/trim.wdl" as concatenated_fastqs
import "../../wdl/workflows/pe/align.wdl" as trimmed_fastqs


workflow concatenate_trim_and_align_pe_fastqs {
    input {
        Array[FastqPair] raw_fastqs = []
        Adapters adapters = {}
        BwaIndex bwa_index
        IndexedFasta indexed_fasta
        Int trim_length
        String machine_size_concatenate = "medium"
        String machine_size_trim = "medium"
        String machine_size_align = "medium"
    }

    call raw_fastqs.concatenate {
        input:
            raw_fastqs=raw_fastqs,
            machine_size=machine_size_concatenate,
    }

    call concatenated_fastqs.trim {
        input:
            concatenated_fastqs=concatenate.concatenated_fastqs,
            adapters=adapters,
            trim_length=trim_length,
            machine_size=machine_size_trim,
    }

    call trimmed_fastqs.align {
        input:
            bwa_index=bwa_index,
            trimmed_fastqs=trim.trimmed_fastqs,
            indexed_fasta=indexed_fasta,
            machine_size=machine_size_align,
    }

    output {
        File trimstats = trim.trimstats
        File name_sorted_bam = align.name_sorted_bam
    }
}
