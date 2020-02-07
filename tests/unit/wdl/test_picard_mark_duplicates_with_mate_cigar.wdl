version 1.0


import "../../../wdl/tasks/picard.wdl"


workflow test_picard_mark_duplicates_with_mate_cigar {
    input {
        File bam
        MarkDuplicatesWithMateCigarParams params
        Resources resources
    }
    
    call picard.mark_duplicates_with_mate_cigar {
        input:
            bam=bam,
            params=params,
            resources=resources,
    }
}
