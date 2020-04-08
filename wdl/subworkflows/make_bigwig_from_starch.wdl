version 1.0


import "../tasks/stampipes.wdl"


workflow make_bigwig_from_starch {
    input {
        File starch
        File fai
        Int bin_size = 20
        Resources resources
    }

    call stampipes.starch_to_bigwig {
        input:
             starch=starch,
             fai=fai,
             resources=resources,
    }

    output {
        File bigwig = starch_to_bigwig.bigwig
    }
}
