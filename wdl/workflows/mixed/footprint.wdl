version 1.0


import "../../../wdl/subworkflows/build_bam_index.wdl" as nuclear_bam
import "../../../wdl/subworkflows/make_bed_from_starch.wdl" as hotspots_starch
import "../../../wdl/subworkflows/fit_footprint_model.wdl" as hotspots_bed
import "../../../wdl/subworkflows/find_significant_footprints.wdl" as dispersion_model
import "../../../wdl/subworkflows/threshold_footprints_and_make_bed.wdl" as deviation_bedgraph


workflow footprint {
    input {
        File nuclear_bam
        File bias_model
        File five_percent_hotspots_starch
        IndexedFastaRequired indexed_fasta
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call nuclear_bam.build_bam_index {
        input:
            bam=nuclear_bam,
            resources=compute.runtimes[machine_size],
    }

    call hotspots_starch.make_bed_from_starch {
        input:
            starch=five_percent_hotspots_starch,
            resources=compute.runtimes[machine_size],
    }

    call hotspots_bed.fit_footprint_model {
        input:
            five_percent_hotspot_bed=make_bed_from_starch.bed,
            bias_model=bias_model,
            indexed_nuclear_bam=build_bam_index.indexed_bam,
            indexed_fasta=indexed_fasta,
            resources=compute.runtimes[machine_size],
    }

    call dispersion_model.find_significant_footprints {
        input:
            dispersion_model=fit_footprint_model.dispersion_model,
            bias_model=bias_model,
            five_percent_hotspot_bed=make_bed_from_starch.bed,            
            indexed_nuclear_bam=build_bam_index.indexed_bam,
            indexed_fasta=indexed_fasta,
            resources=compute.runtimes[machine_size],
            
    }

    call deviation_bedgraph.threshold_footprints_and_make_bed {
        input:
            deviation_bedgraph=find_significant_footprints.deviation_bedgraph,
            resources=compute.runtimes[machine_size],
    }
    
    output {
        File footprints_bed = threshold_footprints_and_make_bed.footprints_bed
    }
}
