version 1.0


import "../../../wdl/workflows/mixed/qc.wdl" as mixed_qc
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

    call mixed_qc.qc as mixed {
        input:
            unfiltered_bam=unfiltered_bam,
            nuclear_bam=nuclear_bam,
            machine_size=machine_size,
    }

    call picard.get_insert_size_metrics as nuclear_insert_size {
        input:
           nuclear_bam=nuclear_bam,
           resources=compute.runtimes[machine_size],
    }

    output {
        UnfilteredBamQC unfiltered_bam_qc = {
            "stats": mixed.unfiltered_bam_qc.stats,
            "flagstats": mixed.unfiltered_bam_qc.flagstats,
            "trimstats": trimstats,
            "bamcounts": mixed.unfiltered_bam_qc.bamcounts
        }
        NuclearBamQC nuclear_bam_qc = {
            "stats": mixed.nuclear_bam_qc.stats,
            "flagstats": mixed.nuclear_bam_qc.flagstats,
            "hotspot1": hotspot1,
            "duplication_metrics": duplication_metrics,
            "preseq": mixed.nuclear_bam_qc.preseq,
            "preseq_targets": mixed.nuclear_bam_qc.preseq_targets,
            "insert_size_metrics": nuclear_insert_size.insert_size_metrics,
            "insert_size_info": nuclear_insert_size.insert_size_info,
            "insert_size_histogram_pdf": nuclear_insert_size.insert_size_histogram_pdf
        }
        PeaksQC peaks_qc = {
            "hotspot2": hotspot2
        }
    }
}
