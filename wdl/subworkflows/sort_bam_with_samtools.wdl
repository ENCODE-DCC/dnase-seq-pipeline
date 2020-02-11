version 1.0


import "../tasks/samtools.wdl"


workflow sort_bam_with_samtools {
    input {
        File bam
        Resources resources
        SamtoolsSortParams params = {
            "compression_level": 0,
            "threads": 1
        }
        String? out 
    }

    call samtools.sort {
        input:
            bam=bam,
            params=params,
            resources=resources,
            out=out,
    }

    output {
        File sorted_bam = sort.sorted_bam
    }
}
