version 1.0


import "../../wdl/structs/dnase.wdl"
import "../../wdl/structs/sizes.wdl"
import "../../wdl/workflows/mixed/unpack.wdl" as packed_references


workflow maybe_unpack_references {
    input {
        References packed_references
        Replicate replicate
        MachineSizes machine_sizes = read_json("wdl/default_machine_sizes.json")
    }

    call packed_references.unpack {
        input:
            packed_references=packed_references,
            read_length=replicate.read_length,
            machine_size=machine_sizes.unpack,
    }

    output {
        References references = unpack.references
    }
}
