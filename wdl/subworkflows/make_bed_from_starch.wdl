version 1.0


import "../tasks/bedops.wdl"


workflow make_bed_from_starch {
    input {
        File starch
        Resources resources
    }

    String out = basename(starch, ".starch") + ".bed"

    call bedops.unstarch {
        input:
             starch=starch,
             out=out,
             resources=resources,
    }

    output {
        File bed = unstarch.bed
    }
}
