version 1.0


import "../tasks/bwa.wdl"


workflow align_fastq_with_bwa {
    input {
        File fastq
        BwaIndex bwa_index
        BwaAlnParams params = {
            "filter_casava": true,
            "probability_missing": 0.04,
            "seed_length": 32
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
