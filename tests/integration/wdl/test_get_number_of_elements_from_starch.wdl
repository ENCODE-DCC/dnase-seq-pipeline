version 1.0


import "../../../wdl/subworkflows/get_number_of_elements_from_starch.wdl" as starch


workflow test_get_number_of_elements_from_starch {
    call starch.get_number_of_elements_from_starch
}
