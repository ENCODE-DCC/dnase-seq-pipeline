version 1.0


import "../../../wdl/subworkflows/unpack_hotspot2_tar_gz_to_struct.wdl"


workflow test_unpack_hotspot2_tar_gz_to_struct {
    call unpack_hotspot2_tar_gz_to_struct.unpack_hotspot2_tar_gz_to_struct
}
