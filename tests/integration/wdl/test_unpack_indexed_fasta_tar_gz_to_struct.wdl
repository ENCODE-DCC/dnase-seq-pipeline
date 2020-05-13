version 1.0


import "../../../wdl/subworkflows/unpack_indexed_fasta_tar_gz_to_struct.wdl"


workflow test_unpack_indexed_fasta_tar_gz_to_struct {
    call unpack_indexed_fasta_tar_gz_to_struct.unpack_indexed_fasta_tar_gz_to_struct
}
