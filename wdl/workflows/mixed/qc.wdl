version 1.0


import "../../../wdl/structs/qc.wdl"
import "../../../wdl/subworkflows/get_stats_and_flagstats_from_bam.wdl" as samtools
import "../../../wdl/subworkflows/get_bamcounts.wdl" as bamcounts
import "../../../wdl/subworkflows/get_preseq_metrics.wdl" as preseq


workflow qc {
    input {
        Boolean? preseq_defects_mode
        File unfiltered_bam
        File nuclear_bam
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call samtools.get_stats_and_flagstats_from_bam as unfiltered_samtools {
        input:
            bam=unfiltered_bam,
            resources=compute.runtimes[machine_size],
    }

    call samtools.get_stats_and_flagstats_from_bam as nuclear_samtools {
        input:
            bam=nuclear_bam,
            resources=compute.runtimes[machine_size],
    }

    call bamcounts.get_bamcounts as unfiltered_bamcounts {
        input:
            bam=unfiltered_bam,
            resources=compute.runtimes[machine_size],
    }

    call preseq.get_preseq_metrics as nuclear_preseq {
        input:
            nuclear_bam=nuclear_bam,
            preseq_defects_mode=select_first([preseq_defects_mode,false]),
            resources=compute.runtimes[machine_size],
    }

    output {
        UnfilteredBamQC unfiltered_bam_qc = {
            "stats": unfiltered_samtools.stats,
            "flagstats": unfiltered_samtools.flagstats,
            "bamcounts": unfiltered_bamcounts.counts
        }
        NuclearBamQC nuclear_bam_qc = {
            "stats": nuclear_samtools.stats,
            "flagstats": nuclear_samtools.flagstats,
            "preseq": nuclear_preseq.preseq,
            "preseq_targets": nuclear_preseq.preseq_targets
        }
    }
}
