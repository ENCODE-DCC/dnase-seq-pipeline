version 1.0


import "../../wdl/tasks/samtools.wdl"


workflow test_samtools_view {
    input {
        File in
        IndexedFasta? indexed_fasta
        SamtoolsViewParams params
        Resources resources
    }
    
    call samtools.view {
        input:
            in=in,
            indexed_fasta=indexed_fasta,
            params=params,
            resources=resources,
    }
}
