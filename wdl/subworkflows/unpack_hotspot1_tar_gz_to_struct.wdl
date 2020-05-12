version 1.0


import "../structs/hotspot1.wdl"
import "../tasks/tar.wdl"


workflow unpack_hotspot1_tar_gz_to_struct {
    input {
        File hotspot1_tar_gz
        String prefix
        Int read_length
        Resources resources
    }

    call tar.untar_and_map_files {
        input:
            tar=hotspot1_tar_gz,
            file_map={
                "chrom_info": "~{prefix}.chromInfo.bed",
                "mappable_regions": "~{prefix}.K~{read_length}.mappable_only.bed"
            },
            resources=resources,
    }
 
    output {
          HotSpot1Reference hotspot1 = untar_and_map_files.out
    }
}
