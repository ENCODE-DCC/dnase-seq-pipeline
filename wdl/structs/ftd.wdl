version 1.0


struct FtdLearnDispersionModelParams {
    Int? half_window_width
    Int? seed
}


struct FtdComputeDeviationParams {
    Int? half_window_width
    Int? smooth_half_window_width
    Float? smooth_clip
    Int? fdr_shuffle_n
    Int? seed
}
