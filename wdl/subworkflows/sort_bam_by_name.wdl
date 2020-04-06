version 1.0


import "../tasks/samtools.wdl"


workflow sort_bam_by_name {
    input {
        File bam
        Resources resources
        SamtoolsSortParams params = object {
            sort_by_name: true
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
        File name_sorted_bam = sort.sorted_bam
    }
}
