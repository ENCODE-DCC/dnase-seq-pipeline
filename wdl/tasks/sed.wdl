version 1.0


import "../structs/resources.wdl"


task remove_trailing_whitespaces {
    input {
        File input_file
        Resources resources
        String out = "out.txt"
    }

    command {
        sed \
            's/[[:blank:]]*$//' \
            ~{input_file} \
            > ~{out}
    }

    output {
        File trailing_whitespace_trimmed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
