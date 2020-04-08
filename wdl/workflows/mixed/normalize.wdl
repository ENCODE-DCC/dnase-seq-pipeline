version 1.0


import "../../../wdl/subworkflows/normalize_density_starch.wdl" as density_starch
import "../../../wdl/subworkflows/make_bigwig_from_starch.wdl" as normalized_density_starch


workflow normalize {
    input {
        File density_starch
        File nuclear_bam
        File chrom_sizes
        String machine_size
    }

    Machines compute = read_json("wdl/runtimes.json")

    call density_starch.normalize_density_starch {
        input:
            density_starch=density_starch,
            nuclear_bam=nuclear_bam,
            resources=compute.runtimes[machine_size],
    }

    call normalized_density_starch.make_bigwig_from_starch {
        input:
            starch=normalize_density_starch.density_starch,
            chrom_sizes=chrom_sizes,
            resources=compute.runtimes[machine_size],
            
    }

    output {
        File normalized_density = normalize_density_starch.density_starch
        File normalized_density_bw = make_bigwig_from_starch.bigwig
    }
}
