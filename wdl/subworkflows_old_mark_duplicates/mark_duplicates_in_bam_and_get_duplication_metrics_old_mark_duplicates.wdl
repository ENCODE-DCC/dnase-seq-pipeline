version 1.0


import "../tasks/picard.wdl"


workflow mark_duplicates_in_bam_and_get_duplication_metrics {
    input {
        File bam
        MarkDuplicatesParams params = {
            "assume_sorted": "true",
            "read_name_regex": "'[a-zA-Z0-9]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+).*'",
            "validation_stringency": "SILENT"
        }
        Resources resources
        String? out
    }
    
    call picard.mark_duplicates {
        input:
            bam=bam,
            params=params,
            resources=resources,
            out=out,
    }

    output {
        File marked = mark_duplicates.marked
        File metrics = mark_duplicates.metrics
    }
}
