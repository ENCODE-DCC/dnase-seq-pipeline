version 1.0


struct Adapters {
    String sequence_R1
    String sequence_R2
}


struct CutadaptParams {
    Boolean? pair_adapters
    Int? minimum_length
    Float? error_rate
}
