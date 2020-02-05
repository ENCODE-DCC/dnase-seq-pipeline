version 1.0


import "../../../wdl/subworkflows/flag_qc_fail_improper_pair_and_nonnuclear_bam_reads.wdl" as flag


workflow test_flag_qc_fail_improper_pair_and_nonnuclear_bam_reads {
      call flag.flag_qc_fail_improper_pair_and_nonnuclear_bam_reads
}
