version 1.0


import "../../../wdl/subworkflows/trim_adapters_on_fastq_pair.wdl" as raw_fastqs
import "../../../wdl/subworkflows/trim_fastq_pair_to_length.wdl" as adapter_trimmed_fastqs


workflow trim {
    input {
        FastqPair raw_fastqs
        File adapters
        Int trim_length = 101
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")
    
    call raw_fastqs.trim_adapters_on_fastq_pair {
        input:
            fastqs=raw_fastqs,
            adapters=adapters,
            resources=compute.runtimes[machine_size],
    }

    call adapter_trimmed_fastqs.trim_fastq_pair_to_length {
        input:
            fastqs=trim_adapters_on_fastq_pair.trimmed_fastqs,
            trim_length=trim_length,
            resources=compute.runtimes[machine_size],
    }
    
    output {
        FastqPair trimmed_fastqs = trim_fastq_pair_to_length.trimmed_fastqs
        File trimstats = trim_adapters_on_fastq_pair.trimstats
    }
}
