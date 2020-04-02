version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_convert_fai_to_bed_format {
    input {
        File fai
        Resources resources
    }

    call awk.convert_fai_to_bed_format {
        input:
            fai=fai,
            resources=resources,
    }
}
