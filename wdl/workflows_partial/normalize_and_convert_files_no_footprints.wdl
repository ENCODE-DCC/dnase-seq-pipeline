version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/structs/hotspot2.wdl"
import "../../wdl/workflows/mixed/normalize.wdl" as density_starch
import "../../wdl/workflows_partial/mixed/convert_no_footprints.wdl" as starches


workflow normalize_and_convert_files {
    input {
        File nuclear_bam
        HotSpot2Peaks tenth_of_one_percent_peaks
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
            five_percent_allcalls_starch=five_percent_peaks.allcalls,
            tenth_of_one_percent_narrow_peaks_starch=tenth_of_one_percent_peaks.narrowpeaks,
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
        File five_percent_allcalls_bigbed = convert.five_percent_allcalls_bigbed
        File tenth_of_one_percent_narrowpeaks_bed_gz = convert.tenth_of_one_percent_narrowpeaks_bed_gz
        File tenth_of_one_percent_narrowpeaks_bigbed = convert.tenth_of_one_percent_narrowpeaks_bigbed
        File five_percent_narrowpeaks_bed_gz = convert.five_percent_narrowpeaks_bed_gz
        File five_percent_narrowpeaks_bigbed = convert.five_percent_narrowpeaks_bigbed
    }
}
