version 1.0


import "../../../wdl/subworkflows/fit_footprint_model.wdl"


workflow test_fit_footprint_model {
    call fit_footprint_model.fit_footprint_model
}
