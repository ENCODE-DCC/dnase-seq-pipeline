version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/workflows/mixed/footprint.wdl" as hotspots


workflow call_footprints {
    input {
        File five_percent_hotspots_starch
        File nuclear_bam
        References references
        MachineSizes machine_sizes
    }

    call hotspots.footprint {
        input:
            five_percent_hotspots_starch=five_percent_hotspots_starch,
            nuclear_bam=nuclear_bam,
            bias_model=select_first([
                references.bias_model
            ]),
            indexed_fasta=select_first([
                references.indexed_fasta
            ]),
            machine_size=machine_sizes.footprint,
    }

    output {
        File one_percent_footprints_bed = footprint.footprints_bed
    }
}
