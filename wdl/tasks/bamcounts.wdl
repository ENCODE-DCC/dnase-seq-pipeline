version 1.0


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
        File out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
