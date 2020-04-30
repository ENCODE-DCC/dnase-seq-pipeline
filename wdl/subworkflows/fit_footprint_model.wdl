version 1.0


import "../tasks/ftd.wdl"


workflow fit_footprint_model {
    input {
        IndexedBam indexed_nuclear_bam
        File? bias_model
        File five_percent_hotspot_bed
        FtdLearnDispersionModelParams params = object {
            half_window_width: 5,
            seed: 12345
        }
        IndexedFastaRequired indexed_fasta
        Resources resources
        String? out
    }

    call ftd.learn_dispersion_model {
        input:
            indexed_bam=indexed_nuclear_bam,
            bias_model=bias_model,
            interval_bed=five_percent_hotspot_bed,
            indexed_fasta=indexed_fasta,
            params=params,
            resources=resources,
            out=out,
    }

    output {
        File dispersion_model = learn_dispersion_model.dispersion_model
    }
}
