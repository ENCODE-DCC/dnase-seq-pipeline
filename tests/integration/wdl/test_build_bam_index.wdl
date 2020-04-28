version 1.0


import "../../../wdl/subworkflows/build_bam_index.wdl"


workflow test_build_bam_index {
    call build_bam_index.build_bam_index
}
