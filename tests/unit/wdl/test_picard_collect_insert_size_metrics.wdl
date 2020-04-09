version 1.0


import "../../../wdl/tasks/picard.wdl"


workflow test_picard_collect_insert_size_metrics {
    input {
        File bam
        CollectInsertSizeMetricsParams params
        Resources resources
    }

    call picard.collect_insert_size_metrics {
        input:
            bam=bam,
            params=params,
            resources=resources,
    }
}
