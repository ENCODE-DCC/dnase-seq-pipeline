version 1.0


import "../structs/resources.wdl"


task remove_trailing_whitespaces {
    input {
        File in
        Resources resources
        String out = "out.txt"
    }

    command {
        sed \
            's/[[:blank:]]*$//' \
            ~{in} \
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


task remove_first_n_lines {
    input {
        File in
        Int number_of_lines
        Resources resources
        String out = "first_n_lines_removed.txt"
    }

    String sed_command = number_of_lines + "d"

    command {
       sed \
          ~{sed_command} \
          ~{in} \
          > ~{out}
    }

    output {
        File first_n_lines_removed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
