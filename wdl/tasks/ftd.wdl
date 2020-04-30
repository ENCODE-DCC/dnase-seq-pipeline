version 1.0


import "../structs/resources.wdl"
import "../structs/ftd.wdl"
import "../structs/samtools.wdl"


task learn_dispersion_model {
    input {
        IndexedBam indexed_bam
        File? bias_model
        File interval_bed
        FtdLearnDispersionModelParams params
        IndexedFasta indexed_fasta
        Resources resources
        String out = "dispersion_model.json"
    }

    command {
        ftd-learn-dispersion-model \
            ~{"--bm " + bias_model} \
            ~{"--half-win-width " + params.half_window_width} \
            ~{"--seed " + params.seed} \
            ~{"--processors " + resources.cpu} \
            ~{indexed_bam.bam} \
            ~{indexed_fasta.fasta} \
            ~{interval_bed} \
            > ~{out}
    }

    output {
        File dispersion_model = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task compute_deviation {
    input {
        IndexedBam indexed_bam
        File? bias_model
        File dispersion_model
        File interval_bed
        FtdComputeDeviationParams params        
        IndexedFasta indexed_fasta
        Resources resources
        String out = "deviation.bedgraph"
    }

    command {
        ftd-compute-deviation \
            ~{"--bm " + bias_model} \
            ~{"--dm " + dispersion_model} \
            ~{"--half-win-width " + params.half_window_width} \
            ~{"--smooth-half-win-width " + params.smooth_half_window_width} \
            ~{"--smooth-clip " + params.smooth_clip} \
            ~{"--fdr-shuffle-n " + params.fdr_shuffle_n} \
            ~{"--seed " + params.seed} \
            ~{"--processors " + resources.cpu} \
            ~{indexed_bam.bam} \
            ~{indexed_fasta.fasta} \
            ~{interval_bed} \
            > ~{out}
    }

    output {
        File deviation_bedgraph = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
