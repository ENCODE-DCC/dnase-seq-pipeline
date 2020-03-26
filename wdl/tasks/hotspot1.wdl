version 1.0


import "../structs/hotspot1.wdl"
import "../structs/resources.wdl"
import "../structs/bwa.wdl"


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
        BwaIndex bwaindex
        File cleaned_fasta
        Int kmer_length
        File out = "enumerated_space.bed" 
        Resources resources
    }

    command {
        perl $(which enumerateUniquelyMappableSpace.pl) \
            ~{kmer_length} \
            ~{bwaindex.fasta} \
            ~{cleaned_fasta}
    }

    output {
        File enumerated_space = out
    }

    runtime {
        cpu: resources.cpu
        memory: "~{resources.memory_gb} GB"
        disks: resources.disks
    }
}

