version 1.0


import "../../../wdl/subworkflows/concatenate_fastq_pairs.wdl" as raw_fastqs


workflow concatenate {
    input {
        Array[FastqPair] raw_fastqs
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call raw_fastqs.concatenate_fastq_pairs {
        input:
            fastqs=raw_fastqs,
            resources=compute.runtimes[machine_size],
    }

    output {
        FastqPair concatenated_fastqs = concatenate_fastq_pairs.concatenated_fastqs
    }
}
