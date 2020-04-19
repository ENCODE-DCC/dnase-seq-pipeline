version 1.0


import "../../../wdl/structs/qc.wdl"
import "../../../wdl/subworkflows/get_insert_size_metrics.wdl" as picard


workflow qc {
    input {
        File nuclear_bam
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call picard.get_insert_size_metrics as nuclear_insert_size {
        input:
            nuclear_bam=nuclear_bam,
            resources=compute.runtimes[machine_size],
    }

    output {
        File insert_size_metrics = nuclear_insert_size.insert_size_metrics
        File insert_size_info = nuclear_insert_size.insert_size_info
        File insert_size_histogram_pdf = nuclear_insert_size.insert_size_histogram_pdf
        }
    }
}
