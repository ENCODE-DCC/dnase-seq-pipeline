version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "../../wdl/workflows/pe/qc.wdl" as pe_qc


workflow calculate_and_gather_pe_qc {
    input {
        File unfiltered_bam
        File nuclear_bam
        File duplication_metrics        
        File spot_score
        File? trimstats
        HotSpot2Peaks five_percent_peaks
        MachineSizes machine_sizes
    }

    call pe_qc.qc {
        input:
            unfiltered_bam=unfiltered_bam,
            nuclear_bam=nuclear_bam,
            trimstats=trimstats,
            duplication_metrics=duplication_metrics,
            hotspot1=spot_score,
            hotspot2=five_percent_peaks.spot_score,
            machine_size=machine_sizes.qc,
    }

    output {
        UnfilteredBamQC unfiltered_bam_qc = qc.unfiltered_bam_qc
        NuclearBamQC nuclear_bam_qc = qc.nuclear_bam_qc
        PeaksQC peaks_qc = qc.peaks_qc
    }
}
