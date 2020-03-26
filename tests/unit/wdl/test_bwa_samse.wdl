version 1.0


import "../../../wdl/tasks/bwa.wdl"


workflow test_bwa_samse {
    input {
        File fastq
        File sai
        BwaIndex bwa_index
        BwaSamseParams params
        Resources resources
    }
    
    call bwa.samse {
        input:
            fastq=fastq,
            sai=sai,
            bwa_index=bwa_index,
            params=params,
            resources=resources,
    }
}
