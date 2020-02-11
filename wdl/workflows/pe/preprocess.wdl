version 1.0


import "../../subworkflows/trim_adapters_on_fastq_pair.wdl" as trim_adapters
# import "../../subworkflows/trim_read_length_on_fastq_pair.wdl" as trim_read_length


workflow preprocess {
    input {
        FastqPair raw_fastqs
        File adapters
        Map[String, Resources] runtimes
        String size
    }
    
    call trim_adapters.trim_adapters_on_fastq_pair {
        input:
            fastqs=raw_fastqs,
            adapters=adapters,
            resources=runtimes[size]
    }

  ##  call trim_read_length.trim_read_length_on_fastq_pair {
  ##      input:
  ##          fastqs=trim_adapters_on_fastq_pair.trimmed_fastqs
  ##  }
    
    output {
        FastqPair trimmed_fastqs = trim_adapters_on_fastq_pair.trimmed_fastqs
        File trimstats = trim_adapters_on_fastq_pair.trimstats
    }
}
