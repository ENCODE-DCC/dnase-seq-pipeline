version 1.0


import "../tasks/stampipes.wdl"


workflow flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
    input {
        File bam
        File nuclear_chroms
        Resources resources
        String? out
    }

    call stampipes.filter_reads {
        input:
            bam=bam,
            nuclear_chroms=nuclear_chroms,
            resources=resources,
            out=out,
    }

    output {
        File flagged_bam = filter_reads.flagged_bam
    }
}
