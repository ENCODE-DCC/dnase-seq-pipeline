version 1.0


import "../../../wdl/tasks/bwa.wdl"


workflow test_bwa_aln {
    input {
        File fastq
        BwaIndex bwa_index
        BwaAlnParams params
        Resources resources
    }
    
    call bwa.aln {
        input:
            fastq=fastq,
            bwa_index=bwa_index,
            params=params,
            resources=resources,
    }
}
