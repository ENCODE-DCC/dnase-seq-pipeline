version 1.0


import "../../../wdl/subworkflows/trim_adapters_on_fastq_pair.wdl" as trim


workflow test_trim_adapters_on_fastq_pair {
    call trim.trim_adapters_on_fastq_pair
}
