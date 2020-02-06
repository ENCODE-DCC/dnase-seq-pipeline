version 1.0


import "../structs/resources.wdl"


task compress {
    input {
        File input_file
        String output_filename
        Resources resources
    }

    command {
        pigz \
            -n \
            -c \
            -p ~{resources.cpu} \
            ~{input_file} \
            > ~{output_filename}
    }

    output {
        File compressed = output_filename
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task decompress {
    input {
        File input_file
        String output_filename
        Resources resources
    }

    command {
        pigz \
            -c \
            -d \
            -p ~{resources.cpu} \
            ~{input_file} \
            > ~{output_filename}
    }

    output {
        File decompressed = output_filename
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
