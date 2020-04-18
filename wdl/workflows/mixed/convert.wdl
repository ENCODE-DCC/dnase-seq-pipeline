version 1.0


import "../../../wdl/subworkflows/make_bed_from_starch.wdl" as unstarch
import "../../../wdl/subworkflows/make_gz_bed_from_bed.wdl" as pigz
import "../../../wdl/subworkflows/make_big_bed_from_narrow_peak_bed.wdl" as ucsc


workflow convert {
    input {
        File five_percent_allcalls_starch
        File five_percent_narrow_peaks_starch
        File narrow_peak_auto_sql
        File chrom_sizes
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call unstarch.make_bed_from_starch as allcalls_unstarch {
        input:
            starch=five_percent_allcalls_starch,
            resources=compute.runtimes[machine_size],
    }

    call unstarch.make_bed_from_starch as narrow_peaks_unstarch {
        input:
            starch=five_percent_narrow_peaks_starch,
            resources=compute.runtimes[machine_size],
    }

    call pigz.make_gz_bed_from_bed as allcalls_pigz {
        input:
            bed=allcalls_unstarch.bed,
            resources=compute.runtimes[machine_size],
    }

    call pigz.make_gz_bed_from_bed as narrow_peaks_pigz {
        input:
            bed=narrow_peaks_unstarch.bed,
            resources=compute.runtimes[machine_size],
    }

    call ucsc.make_big_bed_from_narrow_peak_bed as narrow_peaks_ucsc {
        input:
            narrow_peak_bed=narrow_peaks_unstarch.bed,
            chrom_sizes=chrom_sizes,
            auto_sql=narrow_peak_auto_sql,
            resources=compute.runtimes[machine_size],
    }

    output {
        File five_percent_allcalls_bed_gz = allcalls_pigz.gz_bed
        File five_percent_narrowpeaks_bed_gz = narrow_peaks_pigz.gz_bed
        File five_percent_narrowpeaks_bigbed = narrow_peaks_ucsc.big_bed
    }
}
