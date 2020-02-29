version 1.0


import "../../../wdl/subworkflows/get_first_read_in_pair_from_bam.wdl" as paired_end_bam


workflow test_get_first_read_in_pair_from_bam {
    call paired_end_bam.get_first_read_in_pair_from_bam
}
