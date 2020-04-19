version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../..//wdl/workflows/mixed/qc.wdl" as mixed_qc
import "../..//wdl/subworkflows/get_insert_size_metrics.wdl" as picard



workflow calculate_and_gather_qc {
    input {
        QCFilesCalculate files_for_calculation
        QCFilesGather files_to_gather
        Replicate replicate
        MachineSizes machine_sizes
    }

    Machines compute = read_json("wdl/runtimes.json")

    Boolean paired_only = (
        defined(replicate.pe_fastqs)
        && !defined(replicate.se_fastqs)
    )

    call mixed_qc.qc as mixed {
        input:
            unfiltered_bam=files_for_calculation.unfiltered_bam,
            nuclear_bam=files_for_calculation.nuclear_bam,
            machine_size=machine_sizes.qc
    }

    if (paired_only) {
        call picard.get_insert_size_metrics as nuclear_insert_size {
            input:
                nuclear_bam=files_for_calculation.nuclear_bam,
                resources=compute.runtimes[(
                    select_first([machine_sizes.qc])
                )],
        }
    }

    output {
        UnfilteredBamQC unfiltered_bam_qc = object {
            stats: mixed.unfiltered_bam_qc.stats,
            flagstats: mixed.unfiltered_bam_qc.flagstats,
            trimstats: files_to_gather.trimstats,
            bamcounts: mixed.unfiltered_bam_qc.bamcounts
        }
        NuclearBamQC nuclear_bam_qc = object {
            stats: mixed.nuclear_bam_qc.stats,
            flagstats: mixed.nuclear_bam_qc.flagstats,
            hotspot1: files_to_gather.spot_score,
            duplication_metrics: files_to_gather.duplication_metrics,
            preseq: mixed.nuclear_bam_qc.preseq,
            preseq_targets: mixed.nuclear_bam_qc.preseq_targets,
            insert_size_metrics: nuclear_insert_size.insert_size_metrics,
            insert_size_info: nuclear_insert_size.insert_size_info,
            insert_size_histogram_pdf: nuclear_insert_size.insert_size_histogram_pdf
        }
        PeaksQC peaks_qc = object {
            hotspot2: files_to_gather.five_percent_peaks.spot_score
        }
    }
}
