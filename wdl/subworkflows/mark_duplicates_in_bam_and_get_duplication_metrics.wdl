version 1.0


import "../tasks/picard.wdl"


workflow mark_duplicates_in_bam_and_get_duplication_metrics{
    input {
        File bam
        MarkDuplicatesWithMateCigarParams params
        Resources resources
        String? out
    }
    
    call picard.mark_duplicates_with_mate_cigar {
        input:
            bam=bam,
            params=params,
            resources=resources,
            out=out,
    }

    output {
        File marked = mark_duplicates_with_mate_cigar.marked
        File metrics = mark_duplicates_with_mate_cigar.metrics
    }
}
