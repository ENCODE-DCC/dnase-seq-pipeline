version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_extract_histogram_from_picard_insert_size_metrics {
    input {
        File insert_size_metrics
        Resources resources
    }

    call awk.extract_histogram_from_picard_insert_size_metrics {
        input:
            insert_size_metrics=insert_size_metrics,
            resources=resources,
    }
}
