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


task remove_first_n_lines {
    input {
        File input_file
        Int number_of_lines
        Resources resources
        String out = "first_n_lines_removed.txt"
    }

    String sed_command = number_of_lines + "d"

    command {
       sed \
          ~{sed_command} \
          ~{input_file} \
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
