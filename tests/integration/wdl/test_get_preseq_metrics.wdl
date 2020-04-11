version 1.0


import "../../../wdl/subworkflows/get_preseq_metrics.wdl"


workflow test_get_preseq_metrics {
    call get_preseq_metrics.get_preseq_metrics 
}
