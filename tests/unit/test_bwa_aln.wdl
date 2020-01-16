version 1.0


import "../../tasks/bwa.wdl"


workflow test_bwa_aln {
    call bwa.Aln
}
