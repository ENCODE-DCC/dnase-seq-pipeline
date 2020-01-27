version 1.0

import "../../wdl/tasks/samtools.wdl"


workflow test_index_fasta {
    input{
        File fasta
        Resources resources
    }

    call samtools.index_fasta{
        input:
            fasta=fasta,
            resources=resources,
    }
}
