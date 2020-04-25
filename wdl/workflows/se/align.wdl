version 1.0


import "../../../wdl/subworkflows/align_fastq_with_bwa.wdl" as trimmed_fastq
import "../../../wdl/subworkflows/make_sam_from_sai_and_fastq.wdl" as aligned_fastq
import "../../../wdl/subworkflows/convert_sam_to_bam.wdl" as sam
import "../../../wdl/subworkflows/sort_bam_by_name.wdl" as unsorted_bam


workflow align {
    input {
        BwaIndex bwa_index
        File trimmed_fastq
        IndexedFasta indexed_fasta
        String machine_size = "medium"
        String out = "name_sorted_se.bam"
    }

    Machines compute = read_json("wdl/runtimes.json")
    String machine_size_low_cpu = machine_size + "-low-cpu"

    call trimmed_fastq.align_fastq_with_bwa {
        input:
            bwa_index=bwa_index,
            fastq=trimmed_fastq,
            resources=compute.runtimes[machine_size],
    }

    call aligned_fastq.make_sam_from_sai_and_fastq {
        input:
            bwa_index=bwa_index,
            fastq=trimmed_fastq,
            sai=align_fastq_with_bwa.sai,
            resources=compute.runtimes[machine_size_low_cpu],
    }

    call sam.convert_sam_to_bam {
        input:
            indexed_fasta=indexed_fasta,
            sam=make_sam_from_sai_and_fastq.sam,
            resources=compute.runtimes[machine_size],
    }

    call unsorted_bam.sort_bam_by_name {
        input:
            bam=convert_sam_to_bam.unsorted_bam,
            out=out,
            resources=compute.runtimes[machine_size],
    }

    output {
        File name_sorted_bam = sort_bam_by_name.name_sorted_bam
    }
}
