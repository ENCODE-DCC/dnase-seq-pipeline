version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "../../wdl/workflows/se/qc.wdl" as se_qc


workflow calculate_and_gather_se_qc {
    input {
        QCFilesCalculate files_for_calculation
        QCFilesGather files_to_gather
        MachineSizes machine_sizes
    }

    call se_qc.qc {
        input:
            unfiltered_bam=files_for_calculation.unfiltered_bam,
            nuclear_bam=files_for_calculation.nuclear_bam,
            trimstats=files_to_gather.trimstats,
            duplication_metrics=files_to_gather.duplication_metrics,
            hotspot1=files_to_gather.spot_score,
            hotspot2=files_to_gather.five_percent_peaks.spot_score,
            machine_size=machine_sizes.qc,
    }

    output {
        QC out = object {
            unfiltered_bam_qc: qc.unfiltered_bam_qc,
            nuclear_bam_qc: qc.nuclear_bam_qc,
            peaks_qc: qc.peaks_qc
        }
    }
}
