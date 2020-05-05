version 1.0


import "get_number_of_elements_from_starch.wdl" as unstarch


workflow get_counts_from_hotspot2_peaks {
    input {
        File allcalls
        File hotspots
        File narrowpeaks
        Resources resources
    }

    call unstarch.get_number_of_elements_from_starch as unstarch_allcalls {
        input:
            starch=allcalls,
            resources=resources,
    }

    call unstarch.get_number_of_elements_from_starch as unstarch_hotspots {
        input:
            starch=hotspots,
            resources=resources,
    }

    call unstarch.get_number_of_elements_from_starch as unstarch_narrowpeaks {
        input:
            starch=narrowpeaks,
            resources=resources,
    }

    output {
        Int allcalls_count = unstarch_allcalls.count
        Int hotspots_count = unstarch_hotspots.count
        Int narrowpeaks_count = unstarch_narrowpeaks.count
    }
}
