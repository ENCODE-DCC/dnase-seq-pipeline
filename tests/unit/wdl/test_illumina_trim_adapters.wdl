version 1.0


import "../../../wdl/tasks/illumina.wdl"


workflow test_illumina_trim_adapters {
    input {
        FastqPair fastqs
        File adapters
        Resources resources
    }

    call illumina.trim_adapters {
        input:
            adapters=adapters,
            fastqs=fastqs,
            resources=resources,
    }
}
