version 1.0


import "../tasks/awk.wdl"


workflow get_chrom_info {
    input {
        File chrom_sizes
        Resources resources
    }

    String chrom_info_output = basename(chrom_sizes, ".chrom_sizes.bed") + ".chromInfo.bed"

    call awk.convert_chrom_sizes_to_chrom_info {
        input:
            chrom_sizes=chrom_sizes,
            out=chrom_info_output,
            resources=resources,
    }

    output {
        File chrom_info = convert_chrom_sizes_to_chrom_info.chrom_info
    }
}
