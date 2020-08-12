version 1.0


import "../../../wdl/structs/dnase.wdl"
import "../../../wdl/subworkflows/make_txt_from_txt_gz.wdl" as decompress
import "../../../wdl/subworkflows/unpack_indexed_fasta_tar_gz_to_struct.wdl" as indexed_fasta
import "../../../wdl/subworkflows/unpack_bwa_index_tar_gz_to_struct.wdl" as bwa_index
import "../../../wdl/subworkflows/unpack_hotspot1_tar_gz_to_struct.wdl" as hotspot1
import "../../../wdl/subworkflows/unpack_hotspot2_tar_gz_to_struct.wdl" as hotspot2


workflow unpack {
    input {
        References packed_references
        Int read_length
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")
    String prefix = select_first([
        packed_references.genome_name
    ])

    if (defined(packed_references.indexed_fasta_tar_gz)) {
        call indexed_fasta.unpack_indexed_fasta_tar_gz_to_struct {
            input:
                indexed_fasta_tar_gz=select_first([
                    packed_references.indexed_fasta_tar_gz
                ]),
                prefix=prefix,
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.bwa_index_tar_gz)) {
        call bwa_index.unpack_bwa_index_tar_gz_to_struct {
            input:
                bwa_index_tar_gz=select_first([
                    packed_references.bwa_index_tar_gz
                ]),
                prefix=prefix,
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.hotspot1_tar_gz)) {
        call hotspot1.unpack_hotspot1_tar_gz_to_struct {
            input:
                hotspot1_tar_gz=select_first([
                    packed_references.hotspot1_tar_gz
                ]),
                prefix=prefix,
                read_length=read_length,
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.hotspot2_tar_gz)) {
        call hotspot2.unpack_hotspot2_tar_gz_to_struct {
            input:
                hotspot2_tar_gz=select_first([
                    packed_references.hotspot2_tar_gz
                ]),
                prefix=prefix,
                read_length=read_length,
                resources=compute.runtimes[machine_size],
        }
    }
    
    if (defined(packed_references.bias_model_gz)) {
        call decompress.make_txt_from_txt_gz as unpack_bias_model_gz_to_file {
            input:
                txt_gz=select_first([
                    packed_references.bias_model_gz
                ]),
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.nuclear_chroms_gz)) {
        call decompress.make_txt_from_txt_gz as unpack_nuclear_chroms_gz_to_file {
            input:
                txt_gz=select_first([
                    packed_references.nuclear_chroms_gz
                ]),
                resources=compute.runtimes[machine_size],
        }
    }

    output {
        References references = object {
            genome_name: packed_references.genome_name,
            indexed_fasta: select_first([
                unpack_indexed_fasta_tar_gz_to_struct.indexed_fasta,
                packed_references.indexed_fasta
            ]),
            bwa_index: select_first([
                unpack_bwa_index_tar_gz_to_struct.bwa_index,
                packed_references.bwa_index
            ]),
            hotspot1: select_first([
                unpack_hotspot1_tar_gz_to_struct.hotspot1,
                packed_references.hotspot1
            ]),
            hotspot2: select_first([
                unpack_hotspot2_tar_gz_to_struct.hotspot2,
                packed_references.hotspot2
            ]),
            nuclear_chroms: select_first([
                unpack_nuclear_chroms_gz_to_file.txt,
                packed_references.nuclear_chroms
            ]),
            narrow_peak_auto_sql: packed_references.narrow_peak_auto_sql,
            bias_model: select_first([
                unpack_bias_model_gz_to_file.txt,
                packed_references.bias_model
            ])
        }
    }
}
