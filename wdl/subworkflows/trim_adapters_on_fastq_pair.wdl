version 1.0


import "../tasks/illumina.wdl" 


workflow trim_adapters_on_fastq_pair {
    input {
        FastqPair fastqs
        File adapters
        Resources resources
        String? adapter1
        String? adapter2
        String? read1_out_filename
        String? read2_out_filename
        String? trimstats_out_filename
    }

    call illumina.trim_adapters {
        input:
            adapters=adapters,
            adapter1=adapter1,
            adapter2=adapter2,
            fastqs=fastqs,
            read1_out_filename=read1_out_filename,
            read2_out_filename=read2_out_filename,
            resources=resources,
            trimstats_out_filename=trimstats_out_filename,
    }

    output {
        FastqPair trimmed_fastqs = trim_adapters.trimmed_fastqs
        File trimstats = trim_adapters.trimstats
    }
}
