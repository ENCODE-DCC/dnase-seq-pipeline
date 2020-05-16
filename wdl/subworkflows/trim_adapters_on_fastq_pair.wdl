version 1.0


import "../tasks/illumina.wdl"
import "../tasks/stampipes.wdl"
import "../structs/illumina.wdl"


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
            adapter1=adapters.adapter1,
            adapter2=adapters.adapter2,
            resources=resources,
    }

    call illumina.trim_adapters {
        input:
            adapters=make_adapters_tsv_from_adapter_sequences.adapters_tsv,
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
