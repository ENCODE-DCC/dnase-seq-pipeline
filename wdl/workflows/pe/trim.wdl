version 1.0


import "../subworkflows/trim_adapters_on_fastq_pair.wdl" as raw_fastqs
# import "../../subworkflows/trim_read_length_on_fastq_pair.wdl" as adapter_trimmed_fastqs


workflow trim {
    input {
        FastqPair raw_fastqs
        File adapters
        String machine_size
    }

    Machines compute = read_json("../runtimes.json")
    
    call raw_fastqs.trim_adapters_on_fastq_pair {
        input:
            fastqs=raw_fastqs,
            adapters=adapters,
            resources=compute.runtimes[machine_size]
    }

  ##  call adapter_trimmed_fastqs.trim_read_length_on_fastq_pair {
  ##      input:
  ##          fastqs=trim_adapters_on_fastq_pair.trimmed_fastqs
  ##  }
    
    output {
        FastqPair trimmed_fastqs = trim_adapters_on_fastq_pair.trimmed_fastqs
        File trimstats = trim_adapters_on_fastq_pair.trimstats
    }
}
