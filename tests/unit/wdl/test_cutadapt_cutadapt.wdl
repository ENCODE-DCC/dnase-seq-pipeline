version 1.0


import "../../../wdl/tasks/cutadapt.wdl"
import "../../../wdl/structs/illumina.wdl"


workflow test_cutadapt_cutadapt {
    input {
        FastqPair fastqs
        Adapters adapters
        Resources resources
    }

    call cutadapt.cutadapt {
        input:
            adapters=adapters,
            fastqs=fastqs,
            resources=resources,
    }
}
