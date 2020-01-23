version 1.0


import "../tasks/bwa.wdl"


workflow align_fastq_with_bwa {
    input {
        File fastq
        BwaIndex bwa_index
        BwaAlnParams params
    }

    call bwa.aln {
        input:
            fastq=fastq,
            bwa_index=bwa_index,
            params=params,
    }

    output {
        File sai = aln.sai
    }
}
