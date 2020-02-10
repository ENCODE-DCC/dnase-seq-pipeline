version 1.0


import "../tasks/picard.wdl"


workflow add_mate_cigar_to_bam {
    input {
        File bam
        RevertOriginalBaseQualitiesAndAddMateCigarParams params
        Resources resources
        String? out
    }

    call picard.revert_original_base_qualities_and_add_mate_cigar {
        input:
            bam=bam,
            params=params,
            resources=resources,
            out=out,
    }

    output {
        File mate_cigar_bam = revert_original_base_qualities_and_add_mate_cigar.mate_cigar_bam
    }
}
