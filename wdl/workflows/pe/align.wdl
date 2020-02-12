version 1.0


import "../subworkflows/align_fastq_pair_with_bwa.wdl" as trimmed_fastqs
import "../subworkflows/make_sam_from_sai_and_fastq_pair.wdl" as aligned_fastqs
import "../subworkflows/convert_sam_to_bam.wdl" as sam
import "../subworkflows/sort_bam_with_samtools.wdl" as unsorted_bam


workflow align {
    input {
        BwaIndex bwa_index
        BwaAlnParams params
        FastqPair trimmed_fastqs
        IndexedFasta indexed_fasta
        String machine_size
    }

    Machines compute = read_json("../runtimes.json")

    call trimmed_fastqs.align_fastq_pair_with_bwa {
        input:
            bwa_index=bwa_index,
            fastqs=trimmed_fastqs,
            params=params,
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

    call unsorted_bam.sort_bam_with_samtools {
        input:
            bam=convert_sam_to_bam.unsorted_bam,
            resources=compute.runtimes[machine_size], 
    }

    output {
        File sorted_bam = sort_bam_with_samtools.sorted_bam
    }
}
