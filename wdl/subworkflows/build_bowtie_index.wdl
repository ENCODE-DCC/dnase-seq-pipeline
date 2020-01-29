version 1.0


import "../tasks/bowtie.wdl"


workflow build_bowtie_index {
    input {
       File fasta
       Resources resources
    }

    call bowtie.index {
        input:
            fasta=fasta,
            resources=resources,
    }

    output {
        BowtieIndex bowtie_index = index.bowtie_index
    }
}
