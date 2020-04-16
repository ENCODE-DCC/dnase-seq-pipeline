version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "concatenate_trim_and_align_pe_fastqs.wdl" as pe_fastqs
import "concatenate_trim_and_align_se_fastqs.wdl" as se_fastqs
import "merge_mark_and_filter_bams.wdl" as name_sorted_bams
import "call_hotspots_and_peaks_and_get_spot_score.wdl" as nuclear_bam


workflow dnase_replicate {
    input {
        Replicate replicate
        References references
        MachineSizes machine_sizes = read_json("wdl/default_machine_sizes.json")
    }

    if (defined(replicate.pe_fastqs)) {
        call pe_fastqs.concatenate_trim_and_align_pe_fastqs {
            input:
                replicate=replicate,
                references=references,
                machine_sizes=machine_sizes,
        }
    }

    if (defined(replicate.se_fastqs)) {
        call se_fastqs.concatenate_trim_and_align_se_fastqs {
            input:
                replicate=replicate,
                references=references,
                machine_sizes=machine_sizes,
        }
    }

    Array[File] name_sorted_bams = select_all([
        concatenate_trim_and_align_pe_fastqs.name_sorted_bam,
        concatenate_trim_and_align_se_fastqs.name_sorted_bam
    ])

    call name_sorted_bams.merge_mark_and_filter_bams {
        input:
            name_sorted_bams=name_sorted_bams,
            references=references,
            machine_sizes=machine_sizes,
    }

    call nuclear_bam.call_hotspots_and_peaks_and_get_spot_score {
        input:
            nuclear_bam=merge_mark_and_filter_bams.nuclear_bam,
            replicate=replicate,
            references=references,
            machine_sizes=machine_sizes,
    }

    output {
    }
}
