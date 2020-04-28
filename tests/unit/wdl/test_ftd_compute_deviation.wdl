version 1.0


import "../../../wdl/tasks/ftd.wdl"


workflow test_ftd_compute_deviation {
    input {
        IndexedBam indexed_bam
        File? bias_model
        File dispersion_model
        File interval_bed
        FtdComputeDeviationParams params        
        IndexedFasta indexed_fasta
        Resources resources
        String? out = "deviation.bedgraph"
    }

    call ftd.compute_deviation {
        input:
            indexed_bam=indexed_bam,
            bias_model=bias_model,
            dispersion_model=dispersion_model,
            interval_bed=interval_bed,
            indexed_fasta=indexed_fasta,
            params=params,
            resources=resources,
            out=out,
    }
}
