version 1.0


import "../../../wdl/subworkflows/normalize_density_starch.wdl" as normalize


workflow test_normalize_density_starch {
    call normalize.normalize_density_starch
}
