version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_trim_fastq_reads_to_length {
    input {
        File input_file 
        Int trim_length
        Resources resources
        String output_filename
    }

    call awk.trim_fastq_reads_to_length {
        input:
            input_file=input_file,
            output_filename=output_filename,
            resources=resources,
            trim_length=trim_length,
    }
}
