version 1.0


import "../../../wdl/tasks/illumina.wdl"


workflow test_illumina_trimstats_to_trimcounts {
    input {
        File trimstats
        Resources resources
    }

    call illumina.trimstats_to_trimcounts {
        input:
            resources=resources,
            resources=resources,
    }
}
