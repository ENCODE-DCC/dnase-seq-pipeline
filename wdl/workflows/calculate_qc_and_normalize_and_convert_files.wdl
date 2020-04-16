version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "../../wdl/workflows/mixed/normalize.wdl" as density_starch
import "../../wdl/workflows/mixed/qc.wdl" as bams_and_peaks
import "../../wdl/workflows/mixed/convert.wdl" as starches



workflow calculate_qc_and_normalize_and_convert_files {
    input {
        File unfiltered_bam
        File nuclear_bam
        File duplication_metrics        
        File spot_score
        File? trimstats
        HotSpot2Peaks five_percent_peaks
        References references
        MachineSizes machine_sizes
    }

    IndexedFasta indexed_fasta = select_first([
        references.indexed_fasta
    ])

    call density_starch.normalize {
        input:
            density_starch=five_percent_peaks.density_starch,
            nuclear_bam=nuclear_bam,
            fai=indexed_fasta.fai,
            machine_size=machine_sizes.normalize,
    }

    call bams_and_peaks.qc {
        input:
            unfiltered_bam=unfiltered_bam,
            nuclear_bam=nuclear_bam,
            trimstats=trimstats,
            duplication_metrics=duplication_metrics,
            hotspot1=spot_score,
            hotspot2=five_percent_peaks.spot_score,
            machine_size=machine_sizes.qc,
    }

    call starches.convert {
        input:
            five_percent_allcalls_starch=five_percent_peaks.allcalls,
            five_percent_narrow_peaks_starch=five_percent_peaks.narrowpeaks,
            narrow_peak_auto_sql=select_first([
                references.narrow_peak_auto_sql
            ]),
            chrom_sizes=indexed_fasta.fai,
            machine_size=machine_sizes.convert,   
    }

    output {
        File normalized_density_bw = normalize.normalized_density_bw
        File five_percent_allcalls_bed_gz = convert.five_percent_allcalls_bed_gz
        File five_percent_narrowpeaks_bed_gz = convert.five_percent_narrowpeaks_bed_gz
        File five_percent_narrowpeaks_bigbed = convert.five_percent_narrowpeaks_bigbed
        UnfilteredBamQC unfiltered_bam_qc = qc.unfiltered_bam_qc
        NuclearBamQC nuclear_bam_qc = qc.nuclear_bam_qc
        PeaksQC peaks_qc = qc.peaks_qc
    }
}
