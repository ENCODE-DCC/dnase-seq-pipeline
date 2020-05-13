version 1.0


import "../../../wdl/subworkflows/unpack_bwa_index_tar_gz_to_struct.wdl"


workflow test_unpack_bwa_index_tar_gz_to_struct {
    call unpack_bwa_index_tar_gz_to_struct.unpack_bwa_index_tar_gz_to_struct
}
