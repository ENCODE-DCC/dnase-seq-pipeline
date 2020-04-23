version 1.0


import "../tasks/bwa.wdl"


workflow make_sam_from_sai_and_fastq_pair {
    input {
        FastqPair fastqs
        SaiPair sais
        BwaIndex bwa_index
        BwaSampeParams params = object {
            max_insert_size: 750,
            max_paired_hits: 10,
            keep_index_in_ram: true
        }
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
