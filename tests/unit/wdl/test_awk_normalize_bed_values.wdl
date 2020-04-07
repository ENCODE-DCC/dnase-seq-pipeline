version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_normalize_bed_values {
    input {
        File bed
        Int number_of_reads
        Int scale
        Resources resources
    }

    call awk.normalize_bed_values {
        input:
            bed=bed,
            number_of_reads=number_of_reads,
            scale=scale,
            resources=resources,
    }
}
