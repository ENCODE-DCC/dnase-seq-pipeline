version 1.0


import "../tasks/bwa.wdl"


workflow make_sam_from_sai_and_fastq {
    input {
        File fastq
        File sai
        BwaIndex bwa_index
        BwaSamseParams params = object {
            max_paired_hits: 10
        }
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

    output {
        File sam = samse.sam
    }
}
