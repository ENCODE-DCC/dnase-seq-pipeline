version 1.0


import "../../../wdl/subworkflows/concatenate_fastqs.wdl"


workflow test_concatenate_fastqs {
    call concatenate_fastqs.concatenate_fastqs
}
