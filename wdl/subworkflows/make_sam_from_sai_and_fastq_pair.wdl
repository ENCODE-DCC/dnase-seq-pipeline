version 1.0


import "../tasks/bwa.wdl"


workflow make_sam_from_sai_and_fastq_pair {
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

    output {
        File sam = sampe.sam
    }
}
