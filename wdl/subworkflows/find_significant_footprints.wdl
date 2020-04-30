version 1.0


import "../tasks/ftd.wdl"


workflow find_significant_footprints {
    input {
        IndexedBam indexed_nuclear_bam
        File? bias_model
        File dispersion_model
        File five_percent_hotspot_bed
        FtdComputeDeviationParams params = object {
            half_window_width: 5,
            smooth_half_window_width: 50,
            smooth_clip: 0.01,
            fdr_shuffle_n: 50,
            seed: 12345
        }
        IndexedFasta indexed_fasta
        Resources resources
        String? out
    }

    call ftd.compute_deviation {
        input:
            indexed_bam=indexed_nuclear_bam,
            bias_model=bias_model,
            dispersion_model=dispersion_model,
            interval_bed=five_percent_hotspot_bed,
            indexed_fasta=indexed_fasta,
            params=params,
            resources=resources,
            out=out,
    }
    
    output {
        File deviation_bedgraph = compute_deviation.deviation_bedgraph
    }
}
