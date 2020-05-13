version 1.0


import "../structs/samtools.wdl"
import "../tasks/tar.wdl"


workflow unpack_indexed_fasta_tar_gz_to_struct {
    input {
        File indexed_fasta_tar_gz
        String prefix
        Resources resources
    }

    call tar.untar_and_map_files {
        input:
            tar=indexed_fasta_tar_gz,
            file_map={
                "fasta": "~{prefix}.fa",
                "fai": "~{prefix}.fa.fai"
            },
            resources=resources,
    }
 
    output {
        IndexedFastaRequired indexed_fasta = untar_and_map_files.out
    }
}
