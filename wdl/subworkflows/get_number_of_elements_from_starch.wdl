version 1.0


import "../tasks/cat.wdl"
import "../tasks/bedops.wdl"


workflow get_number_of_elements_from_starch {
    input {
        File starch
        BedopsUnstarchParams params = object {
            elements: true
        }
        Resources resources
    }

    call bedops.unstarch {
        input:
            starch=starch,
            params=params,
            resources=resources,
    }

    call cat.get_int_from_file {
        input:
            in=unstarch.out,
            resources=resources,
    }

    output {
        Int count = get_int_from_file.out
    }
}
