version 1.0


import "../tasks/bwa.wdl"


workflow align_fastq_with_bwa {
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

    output {
        File sai = aln.sai
    }
}
