version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "../../wdl/workflows/pe/qc.wdl" as pe_qc


workflow calculate_and_gather_pe_qc {
    input {
        QCFiles files_to_gather
        MachineSizes machine_sizes
    }

    call pe_qc.qc {
        input:
            unfiltered_bam=files_to_gather.unfiltered_bam,
            nuclear_bam=files_to_gather.nuclear_bam,
            trimstats=files_to_gather.trimstats,
            duplication_metrics=files_to_gather.duplication_metrics,
            hotspot1=files_to_gather.spot_score,
            hotspot2=files_to_gather.five_percent_peaks.spot_score,
            machine_size=machine_sizes.qc,
    }

    output {
        QC out = {
            "unfiltered_bam_qc": qc.unfiltered_bam_qc,
            "nuclear_bam_qc": qc.nuclear_bam_qc,
            "peaks_qc": qc.peaks_qc
        }
    }
}
