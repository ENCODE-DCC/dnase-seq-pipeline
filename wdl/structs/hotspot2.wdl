version 1.0


struct HotSpot2Reference {
    File chrom_sizes
    File center_sites
    File mappable_regions
    
}


struct HotSpot2Params {
    Float hotspot_threshold
    Float? site_call_threshold
    String? peaks_definition
}


struct HotSpot2Peaks {
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
