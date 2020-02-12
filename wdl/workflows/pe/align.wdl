version 1.0


import "../../subworkflows/align_fastq_pair_with_bwa.wdl" as map
import "../../subworkflows/make_sam_from_sai_and_fastq_pair.wdl" as sam
import "../../subworkflows/convert_sam_to_bam.wdl" as bam
import "../../subworkflows/sort_bam_with_samtools.wdl" as sort


workflow align {
    input {
        BwaIndex bwa_index
        FastqPair trimmed_fastqs
        IndexedFasta indexed_fasta
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")

    call map.align_fastq_pair_with_bwa {
        input:
            bwa_index=bwa_index,
            fastqs=trimmed_fastqs,
            resources=compute.runtimes[machine_size],
    }

    call sam.make_sam_from_sai_and_fastq_pair {
        input:
            bwa_index=bwa_index,
            fastqs=trimmed_fastqs,
            sais=align_fastq_pair_with_bwa.sais,
            resources=compute.runtimes[machine_size],
    }

    call bam.convert_sam_to_bam {
        input:
            indexed_fasta=indexed_fasta,
            sam=make_sam_from_sai_and_fastq_pair.sam,
            resources=compute.runtimes[machine_size],
    }

    call sort.sort_bam_with_samtools {
        input:
            bam=convert_sam_to_bam.unsorted_bam,
            resources=compute.runtimes[machine_size], 
    }

    output {
        File sorted_bam = sort_bam_with_samtools.sorted_bam
    }
}
