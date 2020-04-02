version 1.0


import "../../../wdl/tasks/awk.wdl"


workflow test_awk_clean_reference_fasta_headers {
    input {
        File fasta
        Resources resources
    }

    call awk.clean_reference_fasta_headers {
        input:
            fasta=fasta,
            resources=resources,
    }
}
