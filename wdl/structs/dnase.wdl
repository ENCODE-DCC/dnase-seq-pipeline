version 1.0


import "bwa.wdl"
import "fastq.wdl"
import "hotspot1.wdl"
import "hotspot2.wdl"
import "cutadapt.wdl"
import "samtools.wdl"
import "qc.wdl"


struct Replicate {
    Array[FastqPair]? pe_fastqs
    Array[File]? se_fastqs
    Adapters? adapters
    Int read_length
    Int? number
    String? accession
}


struct References {
    String? genome_name
    IndexedFastaRequired? indexed_fasta
    File? indexed_fasta_tar_gz
    BwaIndex? bwa_index
    File? bwa_index_tar_gz
    HotSpot1Reference? hotspot1
    File? hotspot1_tar_gz
    HotSpot2Reference? hotspot2
    File? hotspot2_tar_gz
    File? nuclear_chroms
    File? nuclear_chroms_gz
    File? narrow_peak_auto_sql
    File? bias_model
    File? bias_model_gz
}


struct Analysis {
    Replicate replicate
    File unfiltered_bam
    File nuclear_bam
    File normalized_density_bw
    File five_percent_allcalls_bed_gz
    File five_percent_allcalls_bigbed
    File tenth_of_one_percent_narrowpeaks_bed_gz
    File tenth_of_one_percent_narrowpeaks_bigbed
    File tenth_of_one_percent_peaks_starch
    File five_percent_narrowpeaks_bed_gz
    File five_percent_narrowpeaks_bigbed
    File? one_percent_footprints_bed_gz
    File? one_percent_footprints_bigbed
    QC qc
}
