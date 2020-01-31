version 1.0


import "../../../wdl/subworkflows/build_bwa_index.wdl"


workflow test_build_bwa_index {
      call build_bwa_index.build_bwa_index
}
