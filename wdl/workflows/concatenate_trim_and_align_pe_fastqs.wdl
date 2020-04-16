version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/workflows/pe/concatenate.wdl" as raw_fastqs
import "../../wdl/workflows/pe/trim.wdl" as concatenated_fastqs
import "../../wdl/workflows/pe/align.wdl" as trimmed_fastqs


workflow concatenate_trim_and_align_pe_fastqs {
    input {
        Array[FastqPair] raw_fastqs = []
        Replicate replicate
        References references
        MachineSizes machine_sizes
    }

    call raw_fastqs.concatenate {
        input:
            raw_fastqs=raw_fastqs,
            machine_size=machine_sizes.concatenate,
    }

    call concatenated_fastqs.trim {
        input:
            concatenated_fastqs=concatenate.concatenated_fastqs,
            adapters=replicate.adapters,
            trim_length=replicate.info.read_length,
            machine_size=machine_sizes.trim,
    }

    call trimmed_fastqs.align {
        input:
            bwa_index=references.bwa_index,
            trimmed_fastqs=trim.trimmed_fastqs,
            indexed_fasta=references.indexed_fasta,
            machine_size=machine_sizes.align,
    }

    output {
        File trimstats = trim.trimstats
        File name_sorted_bam = align.name_sorted_bam
    }
}
