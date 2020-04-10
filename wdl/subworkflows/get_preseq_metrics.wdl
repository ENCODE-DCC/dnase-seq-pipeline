version 1.0


import "../tasks/stampipes.wdl"
import "../tasks/preseq.wdl"


workflow get_preseq_metrics {
    input {
    }

    call stampipes.mark_dups {
    }

    call preseq.lc_extrap {
    }

    call stampipes.preseq_targets {
    }
}
