version 1.0


import "../tasks/samtools.wdl"


workflow build_bam_index {
    input {
       File bam
       Resources resources
    }

    call samtools.index {
        input:
            bam=bam,
            resources=resources,
    }

    output {
        IndexedBam indexed_bam = index.indexed_bam
    }
}
