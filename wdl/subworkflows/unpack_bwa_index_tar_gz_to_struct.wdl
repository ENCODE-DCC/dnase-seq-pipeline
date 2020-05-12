version 1.0


import "../structs/bwa.wdl"
import "../tasks/tar.wdl"


workflow unpack_bwa_index_tar_gz_to_struct {
    input {
        File bwa_index_tar_gz
        String prefix
        Resources resources
    }

    call tar.untar_and_map_files {
        input:
            tar=bwa_index_tar_gz,
            file_map={
                "fasta": "~{prefix}.fa",
                "amb": "~{prefix}.fa.amb",
                "ann": "~{prefix}.fa.ann",
                "bwt": "~{prefix}.fa.bwt",
                "pac": "~{prefix}.fa.pac",
                "sa": "~{prefix}.fa.sa"
            },
            resources=resources,
    }
 
    output {
         BwaIndex bwa_index = untar_and_map_files.out
    }
}
