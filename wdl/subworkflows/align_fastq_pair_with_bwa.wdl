version 1.0


import "align_fastq_with_bwa.wdl" as align


workflow align_fastq_pair_with_bwa {
    input {
        FastqPair fastqs
        BwaIndex bwa_index
        BwaAlnParams? params
        Resources resources
        String remove_suffix = ".fastq.gz"
    }

    scatter (fastq in [fastqs.R1, fastqs.R2]) {
        call align.align_fastq_with_bwa as bwa_aln {
            input:
                fastq=fastq,
                bwa_index=bwa_index,
                params=params,
                resources=resources,
                out="~{basename(fastq, remove_suffix)}.sai",
        }
    }

    output {
        SaiPair sais = {
            "S1": bwa_aln.sai[0],
            "S2": bwa_aln.sai[1]
        }
    }
}
