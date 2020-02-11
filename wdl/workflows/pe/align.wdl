version 1.0


import "../../subworkflows/align_fastq_pair_with_bwa.wdl" as map
import "../../subworkflows/make_sam_from_sai_and_fastq_pair.wdl" as sam
import "../../subworkflows/convert_sam_to_bam.wdl" as bam
import "../../subworkflows/sort_bam_with_samtools.wdl" as sort


workflow align {
    input {
        BwaIndex bwa_index
        FastqPair preprocessed_fastqs
        IndexedFasta indexed_fasta
        Map[String, Resources] runtimes
        String size
    }

    call map.align_fastq_pair_with_bwa {
        input:
            bwa_index=bwa_index,
            fastqs=preprocessed_fastqs,
            resources=runtimes[size],
    }

    call sam.make_sam_from_sai_and_fastq_pair {
        input:
            bwa_index=bwa_index,
            fastqs=preprocessed_fastqs,
            sais=align_fastq_pair_with_bwa.sais,
            resources=runtimes[size],
    }

    call bam.convert_sam_to_bam {
        input:
            indexed_fasta=indexed_fasta,
            sam=make_sam_from_sai_and_fastq_pair.sam,
            resources=runtimes[size],
    }

    call sort.sort_bam_with_samtools {
        input:
            bam=convert_sam_to_bam.unsorted_bam,
            resources=runtimes[size],
            
    }

    output {
        File sorted_bam = sort_bam_with_samtools.sorted_bam
    }
}
