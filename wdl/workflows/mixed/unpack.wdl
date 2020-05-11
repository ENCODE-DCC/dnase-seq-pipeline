version 1.0


import "../../../wdl/structs/dnase.wdl"
import "../../../wdl/tasks/tar.wdl"


workflow unpack {
    input {
        References packed_references
        Int read_length
        Int neighborhood_size = 100
        String machine_size = "medium"
    }

    Machines compute = read_json("wdl/runtimes.json")
    String prefix = select_first([
        packed_references.genome_name
    ])

    if (defined(packed_references.indexed_fasta_tar_gz)) {
        call tar.untar_and_map_files as indexed_fasta_map {
            input:
                tar=select_first([
                    packed_references.indexed_fasta_tar_gz
                ]),
                file_map={
                    "fasta": "~{prefix}.fa",
                    "fai": "~{prefix}.fa.fai"
                },
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.bwa_index_tar_gz)) {
        call tar.untar_and_map_files as bwa_index_map {
            input:
                tar=select_first([
                    packed_references.bwa_index_tar_gz
                ]),
                file_map={
                    "fasta": "~{prefix}.fa",
                    "amb": "~{prefix}.fa.amb",
                    "ann": "~{prefix}.fa.ann",
                    "bwt": "~{prefix}.fa.bwt",
                    "pac": "~{prefix}.fa.pac",
                    "sa": "~{prefix}.fa.sa"
                },
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.hotspot1_tar_gz)) {
        call tar.untar_and_map_files as hotspot1_map {
            input:
                tar=select_first([
                    packed_references.hotspot1_tar_gz
                ]),
                file_map={
                    "chrom_info": "~{prefix}.chromInfo.bed",
                    "mappable_regions": "~{prefix}.K~{read_length}.mappable_only.bed"
                },
                resources=compute.runtimes[machine_size],
        }
    }

    if (defined(packed_references.hotspot2_tar_gz)) {
        call tar.untar_and_map_files as hotspot2_map {
            input:
                tar=select_first([
                    packed_references.hotspot2_tar_gz
                ]),
                file_map={
                    "chrom_sizes": "~{prefix}.chrom_sizes.bed",
                    "center_sites": "~{prefix}.K~{read_length}.center_sites.n~{neighborhood_size}.starch",
                    "mappable_regions": "~{prefix}.K~{read_length}.mappable_only.bed"
                },
                resources=compute.runtimes[machine_size],                
        }
    }
    
    output {
        References references = object {
            genome_name: packed_references.genome_name,
            indexed_fasta: select_first([
                indexed_fasta_map.out,
                packed_references.indexed_fasta
            ]),
            bwa_index: select_first([
                bwa_index_map.out,
                packed_references.bwa_index
            ]),
            hotspot1: select_first([
                hotspot1_map.out,
                packed_references.hotspot1
            ]),
            hotspot2: select_first([
                hotspot2_map.out,
                packed_references.hotspot2
            ]),
            nuclear_chroms: packed_references.nuclear_chroms,
            narrow_peak_auto_sql: packed_references.narrow_peak_auto_sql,
            bias_model: packed_references.bias_model
        }
    }
}
