version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_make_adapters_tsv_from_adapter_sequences {
    input {
        String adapter1
        String adapter2
        Resources resources
    }

    call stampipes.make_adapters_tsv_from_adapter_sequences {
        input:
            adapter1=adapter1,
            adapter2=adapter2,
            resources=resources,
    }
}
