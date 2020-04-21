version 1.0


import "../structs/resources.wdl"


task cat {
    input {
        Array[File] files
        Resources resources
        String out = "concatenated"
    }

    command {
        cat \
            ~{sep=" " files} \
            > ~{out}
    }

    output {
        File concatenated = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task get_int_from_file {
    input {
        File in
        Resources resources
    }

    command {
        cat \
            ~{in}
    }

    output {
        Int out = read_int(stdout())
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
