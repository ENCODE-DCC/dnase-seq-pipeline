version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_make_adapters_tsv_from_adapter_sequences {
    input {
        String sequence1
        String sequence2
        Resources resources
    }

    call stampipes.make_adapters_tsv_from_adapter_sequences {
        input:
            sequence1=sequence1,
            sequence2=sequence2,
            resources=resources,
    }
}
