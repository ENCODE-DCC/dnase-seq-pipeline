version 1.0
import "tasks/bwa.wdl" as bwa
workflow build_index {
    File genome_reference_fasta
    String output_prefix
    Int cpu
    Int ramGB
    String disks

    call bwa.index { input:
        genome_reference_fasta = genome_reference_fasta,
        output_prefix = output_prefix,
        cpu = cpu,
        ramGB = ramGB,
        disks = disks,
    }
}

