version 1.0


import "../structs/resources.wdl"


task trim_fastq_reads_to_length {
    input {
        File input_file 
        Int trim_length
        Resources resources
        String output_filename = "trimmed"
    }

    String prefix = basename(input_file)

    command <<<
        ln ~{input_file} .
        awk 'NR%2==0 {print substr($0, 1, ~{trim_length})} NR%2!=0' ~{prefix} \
            > ~{output_filename}
    >>>

    output {
        File trimmed = output_filename
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task shift_bed_reads_start_and_end_range {
    input {
        File bed
        Int bin_size
        Int window_size
        Resources resources
        String out = "shifted.bed"
    }

    command <<<
        awk \
            -v "binI=~{bin_size}" \
            -v "win=~{window_size}" \
            'BEGIN{halfBin=binI/2; shiftFactor=win-halfBin}
            {print $1 "\t" $2 + shiftFactor "\t" $3 - shiftFactor "\t" "id" "\t" $4}' \
            ~{bed} \
            > ~{out}
    >>>

    output {
        File shifted_bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}

