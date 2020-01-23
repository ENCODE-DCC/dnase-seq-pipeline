version 1.0


struct BwaIndex {
    File fasta
    File amb
    File ann
    File bwt
    File pac
    File sa
}


struct BwaAlnParams {
    Int threads
    Int seed_length
    Float probability_missing
    Boolean filter_casava
}
