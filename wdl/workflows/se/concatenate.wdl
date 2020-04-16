version 1.0


import "../../../wdl/subworkflows/concatenate_fastqs.wdl" as raw_fastqs


workflow concatenate {
    input {
        Array[File] raw_fastqs
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call raw_fastqs.concatenate_fastqs {
        input:
            fastqs=raw_fastqs,
            resources=compute.runtimes[machine_size],
    }

    output {
        File concatenated_fastq = concatenate_fastqs.concatenated_fastq
    }
}
