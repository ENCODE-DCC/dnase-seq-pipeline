version 1.0


import "../../../wdl/subworkflows/concatenate_fastq_pairs.wdl"


workflow test_concatenate_fastq_pairs {
    call concatenate_fastq_pairs.concatenate_fastq_pairs
}
