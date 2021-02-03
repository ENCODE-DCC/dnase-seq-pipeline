version 1.0


import "wdl/workflows_partial/dnase_replicate_no_footprints.wdl" as process_no_footprints


workflow dnase {
    input {
        Array[Replicate] replicates
        References references
        MachineSizes? machine_sizes
    }

    scatter (replicate in replicates) {
        call process_no_footprints.dnase_replicate_no_footprints {
            input:
                replicate=replicate,
                references=references,
                machine_sizes=machine_sizes,
        }
    }

    meta {
        version: "v3.0.0"
        caper_docker: "encodedcc/dnase-seq-pipeline:v3.0.0"
    }
}
