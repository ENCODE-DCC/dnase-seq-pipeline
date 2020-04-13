version 1.0


import "../tasks/stampipes.wdl"


workflow get_random_sample_from_bam {
    input {
        File bam
        Int sample_number = 5000000
        Resources resources
        String? out
    }

    call stampipes.random_sample_read1 {
        input:
            bam=bam,
            sample_number=sample_number,
            resources=resources,
            out=out,
    }

    output {
        File subsampled_bam = random_sample_read1.subsampled_bam
    }
}
