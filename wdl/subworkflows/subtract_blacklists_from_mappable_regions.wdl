version 1.0


import "../tasks/bedops.wdl"


workflow subtract_blacklists_from_mappable_regions {
    input {
        Array[File] blacklists
        File mappable_regions
        Resources resources
    }

    String output_bed = basename(mappable_regions)

    call bedops.difference {
        input:
            minuend=mappable_regions,
            out=output_bed,
            resources=resources,
            subtrahends=blacklists,
    }

    output {
        File mappable_regions_subtracted = difference.difference
    }
}
