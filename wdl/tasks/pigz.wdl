version 1.0


import "../structs/pigz.wdl"
import "../structs/resources.wdl"


task pigz{
    input {
        File input_file
        String output_filename="out"
        PigzParams params
        Resources resources
    }
    String prefix = basename(input_file)

    command {
        ln ~{input_file} .
        pigz \
            -c \
            ~{true="-n" false="" params.noname} \
            ~{true="-d" false="" params.decompress} \
            ~{prefix} \
            > ~{output_filename}
    }
    output {
        File out = output_filename 
    }
    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
