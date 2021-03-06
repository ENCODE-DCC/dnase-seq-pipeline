version 1.0


import "../../../wdl/tasks/cutadapt.wdl"
import "../../../wdl/structs/cutadapt.wdl"


workflow test_cutadapt_cutadapt {
    input {
        FastqPair fastqs
        Adapters adapters
        CutadaptParams params
        Resources resources
    }

    call cutadapt.cutadapt {
        input:
            adapters=adapters,
            fastqs=fastqs,
            params=params,
            resources=resources,
    }
}
