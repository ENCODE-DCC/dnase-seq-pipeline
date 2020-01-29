version 1.0


import "../../wdl/subworkflows/build_bowtie_index.wdl"


workflow test_build_bowtie_index {
    call build_bowtie_index.build_bowtie_index
}
