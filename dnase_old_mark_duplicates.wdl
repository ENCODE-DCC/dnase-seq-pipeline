version 1.0


import "wdl/workflows_old_mark_duplicates/dnase_replicate_old_mark_duplicates.wdl" as process


workflow dnase {
    input {
        Array[Replicate] replicates
        References references
        MachineSizes? machine_sizes
    }

    scatter (replicate in replicates) {
        call process.dnase_replicate {
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
