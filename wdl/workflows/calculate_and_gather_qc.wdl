version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../..//wdl/workflows/mixed/qc.wdl" as mixed_qc
import "../..//wdl/workflows/pe/qc.wdl" as pe_qc


workflow calculate_and_gather_qc {
    input {
        QCFilesCalculate files_for_calculation
        QCFilesGather files_to_gather
        Replicate replicate
        MachineSizes machine_sizes
    }

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
        call pe_qc.qc as pe {
            input:
                nuclear_bam=files_for_calculation.nuclear_bam,
                machine_size=machine_sizes.qc,
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
            insert_size_metrics: pe.insert_size_metrics,
            insert_size_info: pe.insert_size_info,
            insert_size_histogram_pdf: pe.insert_size_histogram_pdf
        }
        PeaksQC peaks_qc = object {
            hotspot2: files_to_gather.five_percent_peaks.spot_score,
            five_percent_allcalls_count: files_to_gather.five_percent_peaks.allcalls_count,
            five_percent_hotspots_count: files_to_gather.five_percent_peaks.hotspots_count,
            five_percent_narrowpeaks_count: files_to_gather.five_percent_peaks.narrowpeaks_count,
            tenth_of_one_percent_narrowpeaks_count: files_to_gather.tenth_of_one_percent_peaks.narrowpeaks_count
        }
        FootprintsQC footprints_qc = object {
            dispersion_model: files_to_gather.dispersion_model,
            one_percent_footprints_count: files_to_gather.one_percent_footprints_count
        }
    }
}
