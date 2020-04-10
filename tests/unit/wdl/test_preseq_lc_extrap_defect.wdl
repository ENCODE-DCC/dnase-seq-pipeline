version 1.0


import "../../../wdl/tasks/preseq.wdl"


workflow test_preseq_lc_extrap_defect {
    input {
        File histogram
        PreseqLcExtrapParams params
        Resources resources
    }

    call preseq.lc_extrap {
        input:
            histogram=histogram,
            params=params,
            resources=resources,
    }
}
