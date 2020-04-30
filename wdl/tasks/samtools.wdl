version 1.0


import "../structs/resources.wdl"
import "../structs/samtools.wdl"


task faidx {
    input {
        File fasta
        Resources resources
    }

    String prefix = basename(fasta)

    command {
        ln ~{fasta} .
        samtools faidx ~{prefix}
    }

    output {
        IndexedFasta indexed_fasta = {
            "fasta": prefix,
            "fai": "~{prefix}.fai"
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task view {
    input {
        File in
        IndexedFasta indexed_fasta = {}
        Resources resources
        SamtoolsViewParams params
        String out_path = "out"
    }

    command {
        samtools view \
            ~{"-f " + params.include} \
            ~{"-F " + params.exclude} \
            ~{true="-h" false="" params.include_header} \
            ~{true="-b" false="" params.output_bam} \
            ~{true="-1" false="" params.fast_compression} \
            ~{true="-c" false="" params.count} \
            ~{"-@ " + resources.cpu} \
            ~{"-t " + indexed_fasta.fai} \
            ~{in} \
            > ~{out_path}
    }

    output {
        File out = out_path
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task sort {
    input {
        File bam
        Resources resources
        SamtoolsSortParams params
        String out = "sorted.bam"
    }

    command {
        samtools sort \
            ~{"-l " + params.compression_level} \
            ~{true="-n" false="" params.sort_by_name} \
            ~{"-@ " + resources.cpu} \
            ~{bam} \
            > ~{out}
    }

    output {
        File sorted_bam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task merge {
    input {
        Array[File] sorted_bams
        Resources resources
        SamtoolsMergeParams params
        String out = "merged.bam"
    }

    command {
        samtools merge \
            ~{true="-1" false="" params.fast_compression} \
            ~{true="-n" false="" params.name_sorted} \
            ~{"-@ " + resources.cpu} \
            ~{out} \
            ~{sep=" " sorted_bams}
    }

    output {
        File merged_bam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task stats {
    input {
        File bam
        Resources resources
    }

    String out = basename(bam, ".bam") + ".stats.txt"

    command {
        samtools stats \
            ~{"-@ " + resources.cpu} \
            ~{bam} \
            > ~{out}
    }

    output {
        File bam_stats = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task flagstats {
    input {
        File bam
        Resources resources
    }

    String out = basename(bam, ".bam") + ".flagstats.txt"

    command {
        samtools flagstats \
            ~{"-@ " + resources.cpu} \
            ~{bam} \
            > ~{out}
    }

    output {
        File bam_flagstats = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task index {
    input {
        File bam
        Resources resources
    }

    String prefix = basename(bam)

    command {
        ln ~{bam} .
        samtools index \
            ~{"-@ " + resources.cpu} \
            ~{prefix}
    }

    output {
        IndexedBam indexed_bam = object {
            bam: prefix,
            bai: "~{prefix}.bai"
        }
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
