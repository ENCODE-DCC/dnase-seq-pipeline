version 1.0


import "../../../wdl/subworkflows/align_fastq_pair_with_bwa.wdl" as align


workflow test_align_fastq_pair_with_bwa {
      call align.align_fastq_pair_with_bwa
}
