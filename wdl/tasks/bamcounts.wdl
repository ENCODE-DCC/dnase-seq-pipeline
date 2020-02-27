version 1.0


import "../structs/resources.wdl"


task bamcounts  {
    input {
        File bam
        Resources resources
        String out = "tagcounts.txt"
    }

    command {
        python3 $(which bamcounts.py) \
            ~{bam} \
            ~{out}
    }

    output {
        File counts = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
