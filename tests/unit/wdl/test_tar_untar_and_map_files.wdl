version 1.0


import "../../../wdl/tasks/tar.wdl"


workflow test_tar_untar_and_map_files {
    input {
        File tar
        Map[String, String] file_map
        Resources resources
    }

    call tar.untar_and_map_files {
        input:
            tar=tar,
            file_map=file_map,
            resources=resources,
    }
}
