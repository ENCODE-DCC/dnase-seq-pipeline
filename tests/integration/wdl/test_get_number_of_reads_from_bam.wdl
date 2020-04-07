version 1.0


import "../../../wdl/subworkflows/get_number_of_reads_from_bam.wdl" as bam


workflow test_get_number_of_reads_from_bam {
    call bam.get_number_of_reads_from_bam
}
