version 1.0


import "../tasks/stampipes.wdl"
import "../tasks/preseq.wdl"


workflow get_preseq_metrics {
    input {
        Boolean? preseq_defects_mode
        File nuclear_bam
        Resources resources
    }

    PreseqLcExtrapParams params = object {
        defects: select_first([preseq_defects_mode,false]),
        extrap: "1.001e9",
        step_size: "1e6"
    }

    String output_prefix = basename(nuclear_bam, ".bam")

    call stampipes.mark_dups {
        input:
            bam=nuclear_bam,
            resources=resources,
    }

    call preseq.lc_extrap {
        input:
            histogram=mark_dups.histogram,
            out=output_prefix + ".preseq.txt",
            params=params,
            resources=resources,
    }

    call stampipes.get_preseq_targets {
        input:
            out=output_prefix + ".preseq_targets.txt",
            preseq=lc_extrap.preseq,
            resources=resources,
    }

    output {
        File preseq = lc_extrap.preseq
        File preseq_targets = get_preseq_targets.preseq_targets
    }
}
