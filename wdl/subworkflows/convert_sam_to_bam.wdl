version 1.0


import "../tasks/samtools.wdl"


workflow convert_sam_to_bam {
    input {
        File sam
        IndexedFasta indexed_fasta
        Resources resources
        SamtoolsViewParams params = {
            "output_bam": true
        }
        String out_path = "out.bam"
    }

    call samtools.view {
        input:
            in=sam,
            indexed_fasta=indexed_fasta,
            resources=resources,
            params=params,
            out_path=out_path,
    }

    output {
        File unsorted_bam = view.out
    }
}
