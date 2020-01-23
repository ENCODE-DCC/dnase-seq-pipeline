version 1.0


import "../../wdl/subworkflows/align_fastq_with_bwa.wdl"


workflow test_align_fastq_with_bwa {
      call align_fastq_with_bwa.align_fastq_with_bwa
}
