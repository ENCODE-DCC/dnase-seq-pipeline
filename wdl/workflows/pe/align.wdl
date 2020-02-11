version 1.0


import "../../subworkflows/align_fastq_pair_with_bwa.wdl" as map
import "../../subworkflows/make_sam_from_sai_and_fastq_pair.wdl" as sam
import "../../subworkflows/convert_sam_to_bam.wdl" as bam
import "../../subworkflows/sort_bam_with_samtools.wdl" as sort


workflow align {
    input {
        FastqPair preprocessed_fastqs
    }

    call map.align_fastq_pair_with_bwa {
        input:
            fastqs=preprocessed_fastqs
    }

    call sam.make_sam_from_sai_and_fastq_pair {
        input:
            fastqs=preprocessed_fastqs,
            sais=align_fastq_pair_with_bwa.sais
    }

    call bam.convert_sam_to_bam {
        input:
            sam=make_sam_from_sai_and_fastq_pair.sam
    }

    call sort.sort_bam_with_samtools {
        input:
            bam=convert_sam_to_bam.bam
    }

    output {
        File sorted_bam = sort_bam_with_samtools.sorted_bam
    }
}
