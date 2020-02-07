version 1.0


import "../structs/resources.wdl"


task trim_fastq_to_length {
    input {
        File fastq
        String output_filename
        Resources resources
        Int trim_length
    }

    command <<< 
       awk 'NR%2==0 {print substr($0, 1, ~{trim_length})} NR%2!=0' \
          > ~{output_filename}
    >>>

    output {
        File trimmed_fastq = output_filename
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
