version 1.0


import "../tasks/awk.wdl"
import "../tasks/bedops.wdl"
import "../tasks/hotspot1.wdl"
import "../tasks/sed.wdl"


workflow build_mappable_only_bed {
    input {
        BedopsSortBedParams sortbedparams
        BowtieIndex bowtieindex
        File reference_genome
        Resources resources
        Int kmer_length
    }
    
    call awk.clean_reference_fasta_headers {
        input:
            fasta=reference_genome,
            resources=resources,
    }

    call hotspot1.enumerate_uniquely_mappable_space {
        input:
            bowtieindex=bowtieindex,
            cleaned_fasta=clean_reference_fasta_headers.cleaned_fasta,
            kmer_length=kmer_length,
            resources=resources,
    }

    call awk.merge_adjacent_bed {
        input:
            bed=enumerate_uniquely_mappable_space.enumerated_space,
            resources=resources,
    }

    call sed.remove_whitespace_from_end_of_lines {
        input:
            input_file=merge_adjacent_bed.adjacent_merged_bed,
            resources=resources,
    }

    call bedops.sort_bed {
        input:
            params=sortbedparams,
            resources=resources,
            unsorted_bed=remove_whitespace_from_end_of_lines.end_whitespace_trimmed,
    }

    output {
        File mappable_regions = sort_bed.sorted_bed
    }
}
