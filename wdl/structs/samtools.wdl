version 1.0


struct IndexedFasta {
    File? fasta
    File? fai
}


struct IndexedBam {
    File bam
    File bai
}


struct IndexedSam {
    File sam
    File sai
}


struct SamtoolsViewParams {
    Boolean? output_bam
    Boolean? fast_compression
    Boolean? include_header
    Int? compression_threads
    String? include
    String? exclude
}


struct SamtoolsSortParams {
    Int? compression_level
    Int? threads
}
