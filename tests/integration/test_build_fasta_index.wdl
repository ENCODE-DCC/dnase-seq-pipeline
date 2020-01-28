version 1.0


import "../../wdl/subworkflows/build_fasta_index.wdl"


workflow test_build_fasta_index {
    call build_fasta_index.build_fasta_index
}
