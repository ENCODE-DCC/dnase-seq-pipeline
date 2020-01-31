version 1.0


import "../../wdl/subworkflows/convert_sam_to_bam.wdl" as samtools_view


workflow test_convert_sam_to_bam {
    call samtools_view.convert_sam_to_bam
}
