version 1.0


import "../../../wdl/tasks/stampipes.wdl"


workflow test_stampipes_filter_reads {
    input {
        File bam
        File nuclear_chroms
        Resources resources
        String? out
    }
    
    call stampipes.filter_reads {
        input:
            bam=bam,
            nuclear_chroms=nuclear_chroms,
            resources=resources,
            out=out,
    }
}
