version 1.0


import "../../../wdl/subworkflows/sort_bam_by_coordinate.wdl" as sort


workflow test_sort_bam_by_coordinate {
      call sort.sort_bam_by_coordinate
}
