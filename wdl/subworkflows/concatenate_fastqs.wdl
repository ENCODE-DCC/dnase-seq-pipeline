version 1.0


import "../tasks/cat.wdl"


workflow concatenate_fastqs {
    input {
        Array[File] fastqs
        Resources resources
        String out = "concatenated.fastq.gz"
    }

    call cat.cat {
        input:
            files=fastqs,
            resources=resources,
            out=out,
    }

    output {
        File concatenated_fastq = cat.concatenated
    }
}
