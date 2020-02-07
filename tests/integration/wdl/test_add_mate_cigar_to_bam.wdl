version 1.0


import "../../../wdl/subworkflows/add_mate_cigar_to_bam.wdl"


workflow test_add_mate_cigar_to_bam {
    call add_mate_cigar_to_bam.add_mate_cigar_to_bam
}
