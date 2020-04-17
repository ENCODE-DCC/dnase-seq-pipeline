version 1.0


import "../../../wdl/structs/qc.wdl"
import "../../../wdl/subworkflows/get_stats_and_flagstats_from_bam.wdl" as samtools
import "../../../wdl/subworkflows/get_bamcounts.wdl" as bamcounts
import "../../../wdl/subworkflows/get_preseq_metrics.wdl" as preseq
import "../../../wdl/subworkflows/get_insert_size_metrics.wdl" as picard


workflow qc {
    input {
        File unfiltered_bam
        File nuclear_bam
        File? trimstats
        File duplication_metrics
        File hotspot1
        File hotspot2
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
            resources=compute.runtimes[machine_size],
    }

    if (defined(trimstats)) {
        call picard.get_insert_size_metrics as nuclear_insert_size {
            input:
                nuclear_bam=nuclear_bam,
                resources=compute.runtimes[machine_size],
        }
    }

    output {
        UnfilteredBamQC unfiltered_bam_qc = {
            "stats": unfiltered_samtools.stats,
            "flagstats": unfiltered_samtools.flagstats,
            "trimstats": trimstats,
            "bamcounts": unfiltered_bamcounts.counts
        }
        NuclearBamQC nuclear_bam_qc = {
            "stats": nuclear_samtools.stats,
            "flagstats": nuclear_samtools.flagstats,
            "hotspot1": hotspot1,
            "duplication_metrics": duplication_metrics,
            "preseq": nuclear_preseq.preseq,
            "preseq_targets": nuclear_preseq.preseq_targets,
            "insert_size_metrics": nuclear_insert_size.insert_size_metrics,
            "insert_size_info": nuclear_insert_size.insert_size_info,
            "insert_size_histogram_pdf": nuclear_insert_size.insert_size_histogram_pdf
        }
        PeaksQC peaks_qc = {
            "hotspot2": hotspot2
        }
    }
}
