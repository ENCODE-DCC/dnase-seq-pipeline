version 1.0


import "../../../wdl/subworkflows/make_txt_from_txt_gz.wdl" as txt_gz


workflow test_make_txt_from_txt_gz {
    call txt_gz.make_txt_from_txt_gz
}
