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
        IndexedFasta? indexed_fasta
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
            ~{"-@ " + params.compression_threads} \
            ~{"-t " + indexed_fasta.fai} \
            ~{in} \
            > ~{out_path}
    }

    output {
        File out = out_path
    }
}
