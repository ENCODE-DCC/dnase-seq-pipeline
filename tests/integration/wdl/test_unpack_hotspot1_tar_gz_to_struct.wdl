version 1.0


import "../../../wdl/subworkflows/unpack_hotspot1_tar_gz_to_struct.wdl"


workflow test_unpack_hotspot1_tar_gz_to_struct {
    call unpack_hotspot1_tar_gz_to_struct.unpack_hotspot1_tar_gz_to_struct
}
