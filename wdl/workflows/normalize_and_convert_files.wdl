version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "../../wdl/workflows/mixed/normalize.wdl" as density_starch
import "../../wdl/workflows/mixed/qc.wdl" as bams_and_peaks
import "../../wdl/workflows/mixed/convert.wdl" as starches



workflow normalize_and_convert_files {
    input {
        File nuclear_bam
        File one_percent_footprints_bed
        HotSpot2Peaks five_percent_peaks
        References references
        MachineSizes machine_sizes
    }

    IndexedFastaRequired indexed_fasta = select_first([
        references.indexed_fasta
    ])

    call density_starch.normalize {
        input:
            density_starch=five_percent_peaks.density_starch,
            nuclear_bam=nuclear_bam,
            fai=indexed_fasta.fai,
            machine_size=machine_sizes.normalize,
    }

    call starches.convert {
        input:
            one_percent_footprints_bed=one_percent_footprints_bed,
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
        File one_percent_footprints_bed_gz = convert.one_percent_footprints_bed_gz
        File one_percent_footprints_bigbed = convert.one_percent_footprints_bigbed
    }
}
