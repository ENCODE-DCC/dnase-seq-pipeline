version 1.0


import "hotspot2.wdl"


struct UnfilteredBamQC {
    File? trimstats
    File stats
    File flagstats
    File bamcounts
}


struct NuclearBamQC {
    File stats
    File flagstats
    File? hotspot1
    File? duplication_metrics
    File? preseq
    File? preseq_targets
    File? insert_size_metrics
    File? insert_size_info
    File? insert_size_histogram_pdf
}


struct PeaksQC {
    File hotspot2
}


struct QCFilesCalculate {
    File unfiltered_bam
    File nuclear_bam
}

struct QCFilesGather {
    File duplication_metrics
    File spot_score
    File? trimstats
    HotSpot2Peaks five_percent_peaks
}

struct QC {
    UnfilteredBamQC unfiltered_bam_qc
    NuclearBamQC nuclear_bam_qc
    PeaksQC peaks_qc
}
