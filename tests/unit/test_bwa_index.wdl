version 1.0


import "../../wdl/tasks/bwa.wdl"


workflow test_bwa_index {
    input {
        File fasta
    }
    
    call bwa.index {
        input:
            fasta=fasta
    }
}
