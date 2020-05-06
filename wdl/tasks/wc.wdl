version 1.0


import "../structs/resources.wdl"


task count_lines {
    input {
        File in
        Resources resources
    }

    command {
        wc \
            -l \
            < ~{in}
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
