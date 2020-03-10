version 1.0


import "../../../wdl/tasks/bedops.wdl"


workflow test_bedops_unstarch {
    input {
        File starch
        Resources resources
    }

    call bedops.unstarch {
        input:
            starch=starch,
            resources=resources,
    }
}
