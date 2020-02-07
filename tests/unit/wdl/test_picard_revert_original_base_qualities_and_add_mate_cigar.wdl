version 1.0


import "../../../wdl/tasks/picard.wdl"


workflow test_picard_revert_original_base_qualities_and_add_mate_cigar {
    input {
        File bam
        Resources resources
        RevertOriginalBaseQualitiesAndAddMateCigarParams params
    }
    
    call picard.revert_original_base_qualities_and_add_mate_cigar {
        input:
            bam=bam,
            params=params,
            resources=resources,
    }
}
