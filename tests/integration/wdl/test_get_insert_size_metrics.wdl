version 1.0


import "../../../wdl/subworkflows/get_insert_size_metrics.wdl"


workflow test_get_insert_size_metrics {
    call get_insert_size_metrics.get_insert_size_metrics
}
