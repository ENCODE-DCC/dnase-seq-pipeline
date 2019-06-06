import "../../dnase.wdl" as dnase

workflow test_align {
	Array[File] fastqs
	Boolean UMI
	String? UMI_value
	File adapters
	File reference_index
	File reference
	Int read_length
	Int split_fastq_chunksize
	Int trim_to = 0
	Int threads = 1

	scatter (i in range(length(fastqs))) {
		call dnase.split_fastq { input:
			fastq = fastqs[i],
			fastq_line_chunks = 4 * split_fastq_chunksize,
			read_number = i + 1
		}
	}

	Array[Pair[File, File]] chunked_pairs = zip(dnase.split_fastq.splits[0], dnase.split_fastq.splits[1])

	scatter (pair in chunked_pairs) {
		call dnase.trim_adapters { input:
			read_one = pair.left,
			read_two = pair.right,
			adapters = adapters,
			threads = threads
		}

		if (trim_to > 0) {
			call dnase.trim_to_length { input:
				read_one = dnase.trim_adapters.trimmed_fastqs[0],
				read_two = dnase.trim_adapters.trimmed_fastqs[1],
				trim_to = trim_to
			}
		}

		Array[File] trimmed_fastqs = select_first([dnase.trim_to_length.trimmed_fastqs, dnase.trim_adapters.trimmed_fastqs])

		if (UMI) {
			call dnase.add_umi_info { input:
				read_one = trimmed_fastqs[0],
				read_two = trimmed_fastqs[1],
				UMI_value = UMI_value
			}
		}

		Array[File] fastqs_for_alignment = select_first([dnase.add_umi_info.with_umi, trimmed_fastqs])

		call dnase.align { input:
			read_one = fastqs_for_alignment[0],
			read_two = fastqs_for_alignment[1],
			reference = reference,
			reference_index = reference_index,
			threads = threads
		}
	}
}