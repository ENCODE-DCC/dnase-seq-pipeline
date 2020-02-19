version 1.0


struct Resources {
    Int cpu
    Int memory_gb
    String disks
}


struct Machines {
    Map[String, Resources] runtimes
}
