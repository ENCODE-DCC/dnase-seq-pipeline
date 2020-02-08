version 1.0


import "../structs/resources.wdl"


task trim_to_length {
    input {
        File input_file 
        Int trim_length
        Resources resources
        String output_filename = "trimmed"
    }

    command <<< 
       awk 'NR%2==0 {print substr($0, 1, ~{trim_length})} NR%2!=0' \
          > ~{output_filename}
    >>>

    output {
        File trimmed = output_filename
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
