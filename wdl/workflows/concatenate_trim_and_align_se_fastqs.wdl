version 1.0


import "../../wdl/workflows/se/concatenate.wdl" as raw_fastqs
import "../../wdl/workflows/se/trim.wdl" as concatenated_fastq
import "../../wdl/workflows/se/align.wdl" as trimmed_fastq


workflow concatenate_trim_and_align_se_fastqs {
    input {
        Array[File] raw_fastqs = []
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

    call concatenated_fastq.trim {
        input:
            concatenated_fastq=concatenate.concatenated_fastq,
            trim_length=trim_length,
            machine_size=machine_size_trim,
    }

    call trimmed_fastq.align {
        input:
            bwa_index=bwa_index,
            trimmed_fastq=trim.trimmed_fastq,
            indexed_fasta=indexed_fasta,
            machine_size=machine_size_align,
    }

    output {
        File name_sorted_bam = align.name_sorted_bam
    }
}
