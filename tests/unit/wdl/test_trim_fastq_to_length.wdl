version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_trim_fastq_to_length {
    input {
        File fastq
        Int trim_length
        Resources resources
        String output_filename
    }

    call awk.trim_fastq_to_length {
        input:
            fastq=fastq,
            output_filename=output_filename,
            resources=resources,
            trim_length=trim_length,
    }
}
