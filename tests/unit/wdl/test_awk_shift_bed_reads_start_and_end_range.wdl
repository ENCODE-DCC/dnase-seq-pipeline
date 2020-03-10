version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_shift_bed_reads_start_and_end_range {
    input {
        File bed
        Int bin_size
        Int window_size
        Resources resources
    }

    call awk.shift_bed_reads_start_and_end_range {
        input:
            bed=bed,
            bin_size=bin_size,
            window_size=window_size,
            resources=resources,
    }
}
