version 1.0


import "../../wdl/tasks/awk.wdl"
import "../../wdl/tasks/bedops.wdl"


workflow get_chrom_sizes {
    input {
        File fai
        Resources resources
    }

    call awk.convert_fai_to_bed_format {
        input:
            fai=fai,
            resources=resources,
    }

    call bedops.sort_bed {
        input:
            params=params,
            resources=resources,
            unsorted_bed=convert_fai_to_bed_format.out
    }

    output {
        File chrom_sizes = sort_bed.sorted_bed
    }
}
