version 1.0


import "../../../wdl/tasks/bwa.wdl"


workflow test_bwa_sampe {
    input {
        FastqPair fastqs
        SaiPair sais
        BwaIndex bwa_index
        BwaSampeParams params
        Resources resources
    }
    
    call bwa.sampe {
        input:
            fastqs=fastqs,
            sais=sais,
            bwa_index=bwa_index,
            params=params,
            resources=resources,
    }
}
