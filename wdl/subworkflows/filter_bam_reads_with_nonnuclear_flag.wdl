version 1.0


import "../tasks/samtools.wdl"


workflow filter_bam_reads_with_nonnuclear_flag {
    input {
        File flagged_and_marked_bam
        SamtoolsViewParams params = read_json("../subworkflows/params/filter_bam_reads_with_nonnuclear_flag.json")
        Resources resources
    }

    call samtools.view {
        input:
            in=flagged_and_marked_bam,
            params=params,
            resources=resources,
    }

    output {
        File nuclear = view.out
    }
}
