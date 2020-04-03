version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_convert_chrom_sizes_to_chrom_info {
    input {
        File chrom_sizes
        Resources resources
    }

    call awk.convert_chrom_sizes_to_chrom_info {
        input:
            chrom_sizes=chrom_sizes,
            resources=resources,
    }
}
