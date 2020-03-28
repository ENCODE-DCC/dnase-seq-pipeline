version 1.0


import "../../../wdl/tasks/samtools.wdl"


workflow test_samtools_merge {
    input {
        Array[File] sorted_bams
        SamtoolsMergeParams params
        Resources resources
        String? out
    }
    
    call samtools.merge {
        input:
            sorted_bams=sorted_bams,
            params=params,
            resources=resources,
            out=out,
    }
}
