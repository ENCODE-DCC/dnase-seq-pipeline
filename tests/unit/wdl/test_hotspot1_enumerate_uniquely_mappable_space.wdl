version 1.0


import "../../../wdl/tasks/hotspot1.wdl"


workflow test_hotspot1_enumerate_uniquely_mappable_space {
    input {
        BowtieIndex bowtie_index
        File cleaned_fasta
        Int kmer_length
        Resources resources
    }

    call hotspot1.enumerate_uniquely_mappable_space {
        input:
            bowtie_index=bowtie_index,
            cleaned_fasta=cleaned_fasta,
            kmer_length=kmer_length,
            resources=resources,
    }
}
