version 1.0


import "../tasks/samtools.wdl"


workflow merge_name_sorted_bams {
    input {
        Array[File] name_sorted_bams
        Resources resources
        SamtoolsMergeParams params = object {
            name_sorted: true,
            fast_compression: true
        }
        String? out
    }

    call samtools.merge {
        input:
            sorted_bams=name_sorted_bams,
            params=params,
            resources=resources,
            out=out
    }

    output {
        File merged_bam = merge.merged_bam
    }
}
