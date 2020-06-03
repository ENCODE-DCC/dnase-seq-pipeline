version 1.0


import "../tasks/cutadapt.wdl"
import "../structs/cutadapt.wdl"


workflow trim_adapters_on_fastq_pair {
    input {
        FastqPair fastqs
        Adapters adapters
        Resources resources
        String? read1_out_filename
        String? read2_out_filename
        String? trimstats_out_filename
    }

    call stampipes.make_adapters_tsv_from_adapter_sequences {
        input:
            sequence1=adapters.sequence1,
            sequence2=adapters.sequence2,
            resources=resources,
    }

    call cutadapt.cutadapt {
        input:
            fastqs=fastqs,
            adapters=adapters,
            read1_out_filename=read1_out_filename,
            read2_out_filename=read2_out_filename,
            resources=resources,
            trimstats_out_filename=trimstats_out_filename,
    }

    output {
        FastqPair trimmed_fastqs = cutadapt.trimmed_fastqs
        File trimstats = cutadapt.trimstats
    }
}
