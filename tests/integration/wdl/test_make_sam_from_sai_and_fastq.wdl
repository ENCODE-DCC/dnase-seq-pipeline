version 1.0


import "../../../wdl/subworkflows/make_sam_from_sai_and_fastq.wdl" as bwa_samse


workflow test_make_sam_from_sai_and_fastq {
    call bwa_samse.make_sam_from_sai_and_fastq
}
