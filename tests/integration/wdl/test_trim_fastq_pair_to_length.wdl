version 1.0


import "../../../wdl/subworkflows/trim_fastq_pair_to_length.wdl"


workflow test_trim_fastq_pair_to_length {
    call trim_fastq_pair_to_length.trim_fastq_pair_to_length
}
