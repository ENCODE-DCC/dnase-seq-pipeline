version 1.0


import "../../../wdl/subworkflows/get_random_sample_from_bam.wdl" as nuclear_bam
import "../../../wdl/subworkflows/get_hotspot1_score.wdl" as subsampled_bam


workflow score {
    input {
        File nuclear_bam
        HotSpot1Params params
        HotSpot1Reference reference
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call nuclear_bam.get_random_sample_from_bam {
        input:
            bam=nuclear_bam,
            resources=compute.runtimes[machine_size],
    }

    call subsampled_bam.get_hotspot1_score {
        input:
            subsampled_bam=get_random_sample_from_bam.subsampled_bam,
            params=params,
            reference=reference,
            resources=compute.runtimes[machine_size],
    }

    output {
        File spot_score = get_hotspot1_score.spot_score
    }
}
