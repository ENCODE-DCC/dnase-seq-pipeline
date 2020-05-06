version 1.0


import "../../../wdl/tasks/wc.wdl"


workflow test_wc_count_lines {
    input {
        File in
        Resources resources
    }

    call wc.count_lines {
        input:
            in=in,
            resources=resources,
    }
}
