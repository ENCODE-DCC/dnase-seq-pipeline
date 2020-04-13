version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_random_sample_read1 {
    input {
        File bam
        Int sample_number
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
}
