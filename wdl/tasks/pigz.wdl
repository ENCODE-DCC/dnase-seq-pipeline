version 1.0


import "../structs/resources.wdl"


task pigz{
    input {
        File input_file
        String output_filename
        Boolean compress
        Resources resources
    }
    String action_param =  if compress then "-c -n" else "-c -d" 
    String prefix = basename(input_file)

    command {
        ls ~{input_file} .
        pigz \
            ~{action_param} \
            -p ~{resources.cpu} \
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
