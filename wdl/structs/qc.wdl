version 1.0


struct UnfilteredBamQC {
    File? trimstats
    File stats
    File flagstats
    File bamcounts
}


struct NuclearBamQC {
    File stats
    File flagstats
    File hotspot1
    File duplication_metrics
    File preseq
    File preseq_targets
    File? insert_size_metrics
    File? insert_size_info
    File? insert_size_histogram_pdf
}


struct PeaksQC {
    File hotspot2
}
