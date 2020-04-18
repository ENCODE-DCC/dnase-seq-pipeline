version 1.0


import "../../../wdl/subworkflows/merge_name_sorted_bams.wdl" as name_sorted_bams


workflow merge {
    input {
        Array[File] name_sorted_bams
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call name_sorted_bams.merge_name_sorted_bams {
        input:
            name_sorted_bams=name_sorted_bams,
            resources=compute.runtimes[machine_size],
    }

    output {
        File merged_bam = merge_name_sorted_bams.merged_bam
    }
}
