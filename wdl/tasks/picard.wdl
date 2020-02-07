version 1.0


import "../structs/picard.wdl"
import "../structs/resources.wdl"


task revert_original_base_qualities_and_add_mate_cigar {
    input {
        File bam
        Resources resources
        RevertOriginalBaseQualitiesAndAddMateCigarParams params
        String? out = "mate_cigar.bam"
    }

    command {
        java -jar picard.jar RevertOriginalBaseQualitiesAndAddMateCigar \
            ~{"INPUT=" + bam} \
            ~{"OUTPUT=" + out} \
            ~{"RESTORE_ORIGINAL_QUALITIES=" + params.restore_original_qualities} \
            ~{"VALIDATION_STRINGENCY=" + params.validation_stringency} \
            ~{"MAX_RECORDS_TO_EXAMINE=" + params.max_records_to_examine}
    }

    output {
        File mate_cigar_bam = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task mark_duplicates_with_mate_cigar {
    input {
        File bam
        Resources resources
        MarkDuplicatesWithMateCigarParams params
        String? metrics_path = "MarkDuplicates.picard"
        String? out = "marked.bam"
    }

    command {
        java -jar picard.jar MarkDuplicatesWithMateCigar \
            ~{"INPUT=" + bam} \
            ~{"OUTPUT=" + out} \
            ~{"METRICS_FILE=" + metrics_path} \
            ~{"ASSUME_SORTED=" + params.assume_sorted} \
            ~{"MINIMUM_DISTANCE=" + params.minimum_distance} \
            ~{"READ_NAME_REGEX=" + params.read_name_regex} \
            ~{"VALIDATION_STRINGENCY=" + params.validation_stringency} \
    }

    output {
        File marked = out
        File metrics = metrics_path
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}
