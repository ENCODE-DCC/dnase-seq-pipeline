version 1.0


import "../../../wdl/subworkflows/get_chrom_sizes.wdl"


workflow test_get_chrom_sizes {
    call get_chrom_sizes.get_chrom_sizes 
}
