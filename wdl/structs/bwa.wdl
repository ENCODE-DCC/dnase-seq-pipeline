version 1.0


struct BwaIndex {
    File fasta
    File amb
    File ann
    File bwt
    File pac
    File sa
}


struct SaiPair {
    File S1
    File S2
}


struct BwaAlnParams {
    Int? seed_length
    Float? probability_missing
    Boolean? filter_casava
}


struct BwaSampeParams {
    Int? max_insert_size
    Int? max_paired_hits
}
