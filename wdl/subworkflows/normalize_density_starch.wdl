version 1.0


import "../tasks/awk.wdl"
import "../tasks/bedops.wdl"
import "get_number_of_reads_from_bam.wdl" as nuclear_bam


workflow normalize_density_starch {
    input {
        File density_starch
        File nuclear_bam
        Int scale = 1000000
        Resources resources
    }

    String out = "normalized." + basename(density_starch)

    call nuclear_bam.get_number_of_reads_from_bam {
        input:
            bam=nuclear_bam,
            resources=resources,
    }

    call bedops.unstarch {
        input:
            starch=density_starch,
            resources=resources,
    }

    call awk.normalize_bed_values {
        input:
            bed=unstarch.bed,
            number_of_reads=get_number_of_reads_from_bam.count,
            scale=scale,
            resources=resources,
    }

    call bedops.starch {
        input:
            sorted_bed=normalize_bed_values.normalized_bed,
            resources=resources,
            out=out,
    }

    output {
        File normalized_starch = starch.starch
    }
}
