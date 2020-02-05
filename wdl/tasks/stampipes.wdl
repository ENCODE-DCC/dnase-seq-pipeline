version 1.0


import "../structs/resources.wdl"


task filter_reads {
    input {
        File bam
        File nuclear_chroms
        Resources resources
        String out = "flagged.bam"
    }

    command {
        python3 $(which filter_reads.py) \
            ~{bam} \
            ~{out} \
            ~{nuclear_chroms}
    }

    output {
        File flagged_bam = out
    }
    
    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
