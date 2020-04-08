version 1.0


import "../tasks/awk.wdl"
import "../tasks/picard.wdl"
import "../tasks/sed.wdl"
import "../tasks/stampipes.wdl"


workflow get_insert_size_metrics {
    input {
        CollectInsertSizeMetricsParams params = {
            "assume_sorted": "true",
            "validation_stringency": "LENIENT"
        }
        File nuclear_bam
        Resources resources
    }

    String insert_size_metrics_out = basename(nuclear_bam, ".bam") + ".CollectInsertSizeMetrics.picard"
    String histogram_pdf_out = insert_size_metrics_out + ".pdf"

    String insert_size_info_out = insert_size_metrics_out + ".info"

    call picard.collect_insert_size_metrics {
        input:
            bam=nuclear_bam,
            out=insert_size_metrics_out,
            params=params,
            pdf_out=histogram_pdf_out,
            resources=resources,
    }

    call awk.extract_histogram_from_picard_insert_size_metrics {
        input:
            insert_size_metrics=collect_insert_size_metrics.insert_size_metrics,
            resources=resources,
    }

    call sed.remove_first_n_lines {
        input:
            input_file=extract_histogram_from_picard_insert_size_metrics.histogram,
            number_of_lines=1,
            resources=resources,
    }

    call stampipes.picard_inserts_process {
        input:
            histogram=remove_first_n_lines.first_n_lines_removed,
            out=insert_size_info_out,
            resources=resources,
    }

    output {
        File insert_size_metrics = collect_insert_size_metrics.insert_size_metrics 
        File insert_size_histogram_pdf = collect_insert_size_metrics.histogram_pdf
        File insert_size_info = picard_inserts_process.insert_size_metrics_info
    }
}
