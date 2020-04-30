version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_filter_and_window_footprints_bedgraph {
    input {
        File bedgraph
        Float threshold
        Int window
        Resources resources
    }

    call awk.filter_and_window_footprints_bedgraph {
        input:
            bedgraph=bedgraph,
            threshold=threshold,
            window=window,
            resources=resources,
    }
}
