version 1.0


import "../../../wdl/subworkflows/get_chrom_info.wdl"


workflow test_get_chrom_info {
    call get_chrom_info.get_chrom_info 
}
