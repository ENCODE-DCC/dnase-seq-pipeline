version 1.0


import "../structs/hotspot1.wdl"
import "../structs/resources.wdl"
import "../structs/bowtie.wdl"


task runhotspot {
    input {
        File subsampled_bam
        HotSpot1Reference reference
        HotSpot1Params params
        Resources resources
    }

    String prefix = basename(subsampled_bam, ".bam")

    command {
        ln ~{reference.chrom_info} .
        ln ~{reference.mappable_regions} .
        runhotspot.bash \
            $HOTSPOT_DIRECTORY \
            $PWD \
            ~{subsampled_bam} \
            ~{params.genome_name} \
            ~{params.read_length} \
            DNaseI
    }

    output {
        File spot_score = "~{prefix}.spot.out"
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}


task enumerate_uniquely_mappable_space {
    input {
        BowtieIndex bowtie_index
        File cleaned_fasta
        Int kmer_length
        Resources resources
        String out = "enumerated_space.bed" 
    }

    String bowtie_index_prefix = basename(bowtie_index.ebwt_1, ".1.ebwt")

    command {
        ln ~{bowtie_index.ebwt_1} .
        ln ~{bowtie_index.ebwt_2} .
        ln ~{bowtie_index.ebwt_3} .
        ln ~{bowtie_index.ebwt_4} .
        ln ~{bowtie_index.rev_ebwt1} .
        ln ~{bowtie_index.rev_ebwt2} .
        perl $(which enumerateUniquelyMappableSpace.pl) \
            ~{kmer_length} \
            ~{bowtie_index_prefix} \
            ~{cleaned_fasta} \
            > ~{out}
    }

    output {
        File enumerated_space_bed = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}

