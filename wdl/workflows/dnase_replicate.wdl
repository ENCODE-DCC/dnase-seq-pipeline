version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "concatenate_trim_and_align_pe_fastqs.wdl" as pe_fastqs
import "concatenate_trim_and_align_se_fastqs.wdl" as se_fastqs
import "merge_mark_and_filter_bams.wdl" as name_sorted_bams


workflow dnase_replicate {
    input {
        Replicate replicate
        References references
        MachineSizes sizes
    }

    if (defined(replicate.pe_fastqs)) {
        call pe_fastqs.concatenate_trim_and_align_pe_fastqs {
            input:
                raw_fastqs=replicate.pe_fastqs,
                adapters=replicate.adapters,
                bwa_index=references.bwa_index,
                indexed_fasta=references.indexed_fasta,
                trim_length=replicate.read_length,
                machine_size_concatenate=sizes.concatenate,
                machine_size_trim=sizes.trim,
                machine_size_align=sizes.align,
        }
    }

    if (defined(replicate.se_fastqs)) {
        call se_fastqs.concatenate_trim_and_align_se_fastqs {
            input:
                raw_fastqs=replicate.se_fastqs,
                bwa_index=references.bwa_index,
                indexed_fasta=references.indexed_fasta,
                trim_length=replicate.read_length,                
                machine_size_concatenate=sizes.concatenate,
                machine_size_trim=sizes.trim,
                machine_size_align=sizes.align,
        }
    }

    Array[File] name_sorted_bams = select_all([
        concatenate_trim_and_align_pe_fastqs.name_sorted_bam,
        concatenate_trim_and_align_se_fastqs.name_sorted_bam
    ])

    call name_sorted_bams.merge_mark_and_filter_bams {
        input:
            name_sorted_bams=name_sorted_bams,
            nuclear_chroms=references.nuclear_chroms,
            machine_size_merge=sizes.merge,
            machine_size_mark=sizes.mark,
            machine_size_filter=sizes.filter,
    }

    output {
    }
}
