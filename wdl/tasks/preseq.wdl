version 1.0


import "../structs/preseq.wdl"
import "../structs/resources.wdl"


task lc_extrap {
    input {
        File histogram
        PreseqLcExtrapParams params
        Resources resources
        String out = "preseq.txt"
    }

    command {
        preseq lc_extrap \
            ~{"-hist " + histogram} \
            ~{"-extrap " + params.extrap} \
            ~{"-step " + params.step_size} \
            ~{true="-defects" false="" params.defects} \
            > ~{out}
    }

    output {
        File preseq = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}