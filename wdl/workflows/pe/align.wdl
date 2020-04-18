version 1.0


import "../../../wdl/subworkflows/align_fastq_pair_with_bwa.wdl" as trimmed_fastqs
import "../../../wdl/subworkflows/make_sam_from_sai_and_fastq_pair.wdl" as aligned_fastqs
import "../../../wdl/subworkflows/convert_sam_to_bam.wdl" as sam
import "../../../wdl/subworkflows/sort_bam_by_name.wdl" as unsorted_bam


workflow align {
    input {
        BwaIndex bwa_index
        FastqPair trimmed_fastqs
        IndexedFasta indexed_fasta
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")

    call trimmed_fastqs.align_fastq_pair_with_bwa {
        input:
            bwa_index=bwa_index,
            fastqs=trimmed_fastqs,
            resources=compute.runtimes[machine_size],
    }

    call aligned_fastqs.make_sam_from_sai_and_fastq_pair {
        input:
            bwa_index=bwa_index,
            fastqs=trimmed_fastqs,
            sais=align_fastq_pair_with_bwa.sais,
            resources=compute.runtimes[machine_size],
    }

    call sam.convert_sam_to_bam {
        input:
            indexed_fasta=indexed_fasta,
            sam=make_sam_from_sai_and_fastq_pair.sam,
            resources=compute.runtimes[machine_size],
    }

    call unsorted_bam.sort_bam_by_name {
        input:
            bam=convert_sam_to_bam.unsorted_bam,
            out="name_sorted_pe.bam",
            resources=compute.runtimes[machine_size],
    }

    output {
        File name_sorted_bam = sort_bam_by_name.name_sorted_bam
    }
}
