version 1.0


import "../../../wdl/subworkflows/get_random_sample_from_bam.wdl" as bam


workflow test_get_random_sample_from_bam {
    call bam.get_random_sample_from_bam
}
