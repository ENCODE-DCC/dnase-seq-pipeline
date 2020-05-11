version 1.0


import "../../../wdl/tasks/bedops.wdl"


workflow test_bedops_difference {
    input {
        Array[File] subtrahends
        File minuend
        Resources resources
    }

    call bedops.difference {
        input:
            minuend=minuend,
            resources=resources,
            subtrahends=subtrahends,
    }
}
