version 1.0


import "../../../wdl/tasks/picard.wdl"


workflow test_picard_mark_duplicates {
    input {
        File bam
        MarkDuplicatesParams params
        Resources resources
    }
    
    call picard.mark_duplicates {
        input:
            bam=bam,
            params=params,
            resources=resources,
    }
}
