version 1.0


import "../tasks/samtools.wdl"


workflow build_fasta_index {
    input {
       File fasta
       Resources resources
    }

    call samtools.index_fasta {
        input:
            fasta=fasta,
            resources=resources,
    }

    output {
        IndexedFasta indexed_fasta = index_fasta.indexed_fasta
    }
}
