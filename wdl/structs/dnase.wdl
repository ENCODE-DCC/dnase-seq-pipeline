version 1.0


import "bwa.wdl"
import "fastq.wdl"
import "hotspot1.wdl"
import "hotspot2.wdl"
import "illumina.wdl"
import "samtools.wdl"


struct Replicate {
    Array[FastqPair]? pe_fastqs
    Array[File]? se_fastqs
    Adapters? adapters
    Int read_length
    Int number
    String? accession
}


struct References {
    String genome_name
    IndexedFasta indexed_fasta
    BwaIndex bwa_index
    HotSpot1Reference hotspot1
    HotSpot2Reference hotspot2
}
