version 1.0


import "../../../wdl/tasks/ftd.wdl"


workflow test_ftd_learn_dispersion_model {
    input {
        IndexedBam indexed_bam
        File? bias_model
        File interval_bed
        FtdLearnDispersionModelParams params
        IndexedFasta indexed_fasta
        Resources resources
        String? out
    }

    call ftd.learn_dispersion_model {
        input:
            indexed_bam=indexed_bam,
            bias_model=bias_model,
            interval_bed=interval_bed,
            indexed_fasta=indexed_fasta,
            params=params,
            resources=resources,
            out=out,
    }
}
