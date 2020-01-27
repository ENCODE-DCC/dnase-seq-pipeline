version 1.0


import "../../wdl/subworkflows/make_sam_from_sai_and_fastq_pair.wdl" as bwa_sampe


workflow test_make_sam_from_sai_and_fastq_pair {
    call bwa_sampe.make_sam_from_sai_and_fastq_pair
}
