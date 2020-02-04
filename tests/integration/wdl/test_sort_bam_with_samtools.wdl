version 1.0


import "../../../wdl/subworkflows/sort_bam_with_samtools.wdl" as sort


workflow test_sort_bam_with_samtools {
      call sort.sort_bam_with_samtools
}
