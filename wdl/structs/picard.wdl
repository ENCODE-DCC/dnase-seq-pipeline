version 1.0


struct RevertOriginalBaseQualitiesAndAddMateCigarParams {
    Int? max_records_to_examine
    String? restore_original_qualities
    String? sort_order
    String? validation_stringency
}


struct MarkDuplicatesWithMateCigarParams {
    String? assume_sorted
    Int? minimum_distance
    String? read_name_regex
    String? validation_stringency
}


struct CollectInsertSizeMetricsParams {
    String? assume_sorted
    String? validation_stringency
}
