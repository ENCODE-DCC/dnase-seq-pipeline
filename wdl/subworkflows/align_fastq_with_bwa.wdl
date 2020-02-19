version 1.0


import "../tasks/bwa.wdl"


workflow align_fastq_with_bwa {
    input {
        File fastq
        BwaIndex bwa_index
        BwaAlnParams params = object {
            filter_casava: true,
            seed_length: 32,
            probability_missing: 0.04
        }
        Resources resources
        String? out
    }

    call bwa.aln {
        input:
            fastq=fastq,
            bwa_index=bwa_index,
            params=params,
            resources=resources,
            out=out,
    }

    output {
        File sai = aln.sai
    }
}
