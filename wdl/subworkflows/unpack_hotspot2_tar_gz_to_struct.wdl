version 1.0


import "../structs/hotspot2.wdl"
import "../tasks/tar.wdl"


workflow unpack_hotspot2_tar_gz_to_struct {
    input {
        File hotspot2_tar_gz
        String prefix
        Int read_length
        Int neighborhood_size = 100
        Resources resources
    }

    call tar.untar_and_map_files {
        input:
            tar=hotspot2_tar_gz,
            file_map={
                "chrom_sizes": "~{prefix}.chrom_sizes.bed",
                "center_sites": "~{prefix}.K~{read_length}.center_sites.n~{neighborhood_size}.starch",
                "mappable_regions": "~{prefix}.K~{read_length}.mappable_only.bed"
            },
            resources=resources,
    }
 
    output {
          HotSpot2Reference hotspot2 = untar_and_map_files.out
    }
}
