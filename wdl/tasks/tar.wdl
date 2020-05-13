version 1.0


import "../structs/resources.wdl"


task untar_and_map_files {
    input {
        File tar
        Map[String, String] file_map
        Resources resources
    }

    command {
        tar \
            -xvzf \
            ~{tar} \
            -C .
    }

    output {
        Map[String, File] out = file_map
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
