version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/workflows/se/concatenate.wdl" as raw_fastqs
import "../../wdl/workflows/se/trim.wdl" as concatenated_fastq
import "../../wdl/workflows/se/align.wdl" as trimmed_fastq


workflow concatenate_trim_and_align_se_fastqs {
    input {
        Replicate replicate
        References references
        MachineSizes machine_sizes
    }

    Array[File] raw_fastqs = select_first([
        replicate.se_fastqs
    ])

    call raw_fastqs.concatenate {
        input:
            raw_fastqs=raw_fastqs,
            machine_size=machine_sizes.concatenate,
    }

    call concatenated_fastq.trim {
        input:
            concatenated_fastq=concatenate.concatenated_fastq,
            trim_length=replicate.read_length,
            machine_size=machine_sizes.trim,
    }

    call trimmed_fastq.align {
        input:
            bwa_index=select_first([
                references.bwa_index
            ]),
            trimmed_fastq=trim.trimmed_fastq,
            indexed_fasta=select_first([
                references.indexed_fasta
            ]),
            machine_size=machine_sizes.align,
    }

    output {
        File name_sorted_bam = align.name_sorted_bam
    }
}
