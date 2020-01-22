version 1.0


import "wdl/tasks/bwa.wdl"


workflow test_bwa_aln {
    call bwa.aln
}
