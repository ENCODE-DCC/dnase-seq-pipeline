version 1.0


struct HotSpot2Index {
    String chrom_sizes
    String center_sites
    String mappable_regions
    
}


struct HotSpot2Params {
    Float hotspot_threshold
    Float? site_call_threshold
    String? peaks_definition
}


struct HotSpot2Output {
    File allcalls
    File cleavage
    File cutcounts
    File density_bed
    File density_bw
    File fragments
    File hotspots
    File peaks
    File narrowpeaks
    File spot_score
}
