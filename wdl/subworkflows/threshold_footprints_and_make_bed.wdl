version 1.0


import "../tasks/awk.wdl"
import "../tasks/bedops.wdl"


workflow threshold_footprints_and_make_bed {
    input {
        File deviation_bedgraph
        Float threshold = 0.01
        Int window = 3
        Resources resources
    }

    call awk.filter_and_window_footprints_bedgraph {
        input:
            bedgraph=deviation_bedgraph,
            threshold=threshold,
            window=window,
            resources=resources,
    }

    call bedops.sort_bed {
        input:
            unsorted_bed=filter_and_window_footprints_bedgraph.footprints_bedgraph,
            params=object {
                max_memory: "~{resources.cpu}G"
            },
            resources=resources,
    }

    call bedops.merge {
        input:        
            sorted_bed=sort_bed.sorted_bed,
            resources=resources,
    }

    call awk.add_name_and_score_to_footprints_bed {
        input:
            bed=merge.merged_bed,
            threshold=threshold,
            resources=resources,
    }

    output {
        File footprints_bed = add_name_and_score_to_footprints_bed.footprints_bed 
    }
}
