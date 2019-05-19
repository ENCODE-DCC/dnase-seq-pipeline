workflow dnase {
	
	Array[File] bams
	Boolean UMI
	File? hotspot_index
	File mappable
	File chrom_info
	File chrom_bucket
	File nuclear_chroms
	File reference
	Int read_length


	call merge {input:
		bams = bams
	}

	String dups_cmd = 	if UMI then 'UmiAwareMarkDuplicatesWithMateCigar' 
							   else 'MarkDuplicatesWithMateCigar'
	String dups_extra = if UMI then 'UMI_TAG_NAME=XD'
					           else '' 
	call dups {input:
		merged_bam = merge.merged_bam,
		cmd = dups_cmd,
		extra = dups_extra
	}

	Int flag = if UMI then 1536 else 512
	call filter {input:
		marked_bam = dups.marked_bam,
		flag = flag
	}

	call bam_counts {input:
		marked_bam = dups.marked_bam
	}

	call count_adaptors {input:
		marked_bam = dups.marked_bam
	}

	call hotspot2 {input:
		filtered_bam = filter.filtered_bam,
		mappable = mappable
	}

	if ( defined(hotspot_index) ) {
		call differential_hotspots {input:
			marked_bam = dups.marked_bam,
			onepercent_peaks = hotspot2.onepercent_peaks,
			index = hotspot_index
		}
	}

	call spot_score {input:
		filtered_bam = filter.filtered_bam,
		mappable = mappable,
		chrom_info = chrom_info,
		read_length = read_length
	}

	call cutcounts {input:
		filtered_bam = filter.filtered_bam,
		reference = reference
	}

	call density {input:
		filtered_bam = filter.filtered_bam,
		chrom_bucket = chrom_bucket,
		reference = reference
	}

	output {

	}
}

task merge {
	Array[File] bams

	command {
		samtools merge merged.bam ${sep=' ' bams}
	}

	output {
		File merged_bam = glob("merged.bam")[0]
	}
}

task dups {
	File merged_bam
	String cmd
	String extra

	command {
		picard RevertOriginalBaseQualitiesAndAddMateCigar \
			INPUT=${merged_bam} OUTPUT=cigar.bam \
			VALIDATION_STRINGENCY=SILENT RESTORE_ORIGINAL_QUALITIES=false SORT_ORDER=coordinate MAX_RECORDS_TO_EXAMINE=0

		picard ${cmd} \
		  	INPUT=cigar.bam OUTPUT=marked.bam \
		  	${extra} \
		  	METRICS_FILE=MarkDuplicates.picard ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT \
		  	READ_NAME_REGEX='[a-zA-Z0-9]+:[0-9]+:[a-zA-Z0-9]+:[0-9]+:([0-9]+):([0-9]+):([0-9]+).*'

		samtools index marked.bam
	}

	output {
		File marked_bam = 		 glob('marked.bam')[0]
		File marked_bam_bai = 	 glob('marked.bam.bai')[0]
		File marked_dup_picard = glob('MarkDuplicates.picard')[0]
	}

	runtime {
		cpu: 2
		memory: "32000 MB"
	}
}


task filter {
	File marked_bam
	Int flag

	command {
		samtools view -b -F ${flag} ${marked_bam} > filtered.bam
	}

	output {
		File filtered_bam = glob('filtered.bam')[0]
	}
}

task bam_counts {
	File marked_bam 

	command {
		python3 $STAMPIPES/scripts/bwa/bamcounts.py \
    		${marked_bam} \
    		tagcounts.txt
	}

	output {
		File tagcounts = glob('tagcounts.txt')[0]
	}
}

task count_adaptors {
	File marked_bam 

	command {
		bash $STAMPIPES/scripts/bam/count_adapters.sh ${marked_bam} \
  	    	| sed 's/^/adapter\t/' > adapter.counts.txt
	}

	output {
		File adapter_counts = glob('adapter.counts.txt')[0]
	}
}

task hotspot2 {
	File filtered_bam
	File mappable
	File chrom_sizes
	File centers

	command {
		export TMPDIR=$(mktemp -d)
		hotspot2.sh -F 0.5 -p varWidth_20_default \
			-M "${mappable}" \
		    -c "${chrom_sizes}" \
		    -C "${centers}" \
		    "${filtered_bam}" \
		    '.'

	  	# Rename peaks files to include FDR
	  	mv filtered.peaks.narrowpeaks.starch filtered.peaks.narrowpeaks.fdr0.05.starch
	 	mv filtered.peaks.starch filtered.peaks.fdr0.05.starch

	  	bash $STAMPIPES/scripts/SPOT/info.sh \
	    	filtered.hotspots.fdr0.05.starch hotspot2 filtered.SPOT.txt \
	    	> filtered.hotspot2.info

	  	# TODO: Move this to separate process
	  	hsmerge.sh -f 0.01 filtered.allcalls.starch filtered.hotspots.fdr0.01.starch
	  	hsmerge.sh -f 0.001 filtered.allcalls.starch filtered.hotspots.fdr0.001.starch

	  	density-peaks.bash $TMPDIR varWidth_20_default filtered.cutcounts.starch filtered.hotspots.fdr0.01.starch ${chrom_sizes} filtered.density.starch filtered.peaks.fdr0.01.starch $(cat filtered.cleavage.total)
	  	density-peaks.bash $TMPDIR varWidth_20_default filtered.cutcounts.starch filtered.hotspots.fdr0.001.starch ${chrom_sizes} filtered.density.starch filtered.peaks.fdr0.001.starch $(cat filtered.cleavage.total)

	  	rm -rf $TMPDIR
	}

	output {
		File hotspot_calls = glob('filtered.hotspots.fdr0.05.starch')[0]
		File onepercent_peaks = glob('filtered.peaks.fdr0.001.starch')[0]
	}

	runtime {
		docker: "fwip/hotspot2:latest"
	}
}



task differential_hotspots {
	File marked_bam
	File onepercent_peaks
	File index

	command {
		# TODO
	}

	output {

	}
}

task spot_score {
	File filtered_bam
	File mappable
	File chrom_info
	Int read_length

	command <<<
		# random sample
		samtools view -h -F 12 -f 3 ${filtered_bam} \
			| awk '{if( ! index($3, "chrM") && $3 != "chrC" && $3 != "random") {print}}' \
			| samtools view -uS - \
			> nuclear.bam
		bash $STAMPIPES/scripts/bam/random_sample.sh nuclear.bam subsample.bam 5000000
  		samtools view -b -f 0x0040 subsample.bam > r1.bam

  		ln ${chrom_info} .
  		ln ${mappable} .
  		# hotspot
  		bash $STAMPIPES/scripts/SPOT/runhotspot.bash \
    		$HOTSPOT_DIR \
    		$PWD \
    		$PWD/r1.bam \
    		$(basename ${chrom_info} '.chromInfo.bed') \
    		${read_length} \
    		DNaseI

  		starch --header r1-both-passes/r1.hotspot.twopass.zscore.wig \
    		> r1.spots.starch

  		bash $STAMPIPES/scripts/SPOT/info.sh \
    		r1.spots.starch hotspot1 r1.spot.out \
    		> r1.hotspot.info
	>>>

	output {
		File r1_spot_info = glob('r1.spot.out')[0]
		File r1_hotspot_info = glob('r1.hotspot.info')[0]
	}

}

task cutcounts {
	File filtered_bam
	File reference

	command <<<
		bam2bed --do-not-sort \
			< ${filtered_bam} \
			| awk -v cutfile=cuts.bed -v fragmentfile=fragments.bed -f $STAMPIPES/scripts/bwa/aggregate/basic/cutfragments.awk

		sort-bed fragments.bed | starch - > fragments.starch
		sort-bed cuts.bed | starch - > cuts.starch

		unstarch cuts.starch \
			| cut -f1-3 \
			| bedops -m - \
			| awk '{ for(i = $2; i < $3; i += 1) { print $1"\t"i"\t"i + 1 }}' \
			> allbase.tmp

		unstarch cuts.starch \
			| bedmap --echo --count --delim "\t" allbase.tmp - \
			| awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' \
			| starch - > cutcounts.starch

		# Bigwig
		$STAMPIPES/scripts/bwa/starch_to_bigwig.bash \
			cutcounts.starch \
			cutcounts.bw \
			${reference}

		# tabix
		unstarch cutcounts.starch | bgzip > cutcounts.bed.bgz
		tabix -p bed cutcounts.bed.bgz
	>>>

	output {
		File fragments_starch = glob('fragments.starch')[0]
		File cutcounts_starch = glob('cutcounts.starch')[0]
		File cutcounts_bw = glob('cutcounts.bw')[0]
		File cutcounts_bed_bgz = glob('cutcounts.bed.bgz')[0]
		File cutcounts_bed_bgz_tbi = glob('cutcounts.bed.bgz.tbi')[0]
	}
}

task density {
	File filtered_bam
	File reference
	File chrom_bucket

	Int window_size = 75
	Int bin_size = 20
	String scale = '1_000_000'

	command <<<
		mkfifo density.bed

		bam2bed -d \
			< ${filtered_bam} \
			| cut -f1-6 \
			| awk '{ if( $6=="+" ){ s=$2; e=$2+1 } else { s=$3-1; e=$3 } print $1 "\t" s "\t" e "\tid\t" 1 }' \
			| sort-bed - \
			> density.bed \
			&

		unstarch ${chrom_bucket} \
			| bedmap --faster --echo --count --delim "\t" - density.bed \
			| awk -v "binI=${bin_size}" -v "win=${window_size}" \
	    	'BEGIN{ halfBin=binI/2; shiftFactor=win-halfBin } { print $1 "\t" $2 + shiftFactor "\t" $3-shiftFactor "\tid\t" i $4}' \
			| starch - \
			> density.starch

		# Bigwig
		$STAMPIPES/scripts/bwa/starch_to_bigwig.bash \
			density.starch \
			density.bw \
			${reference} \
			${bin_size}

		# Tabix
		unstarch density.starch | bgzip > density.bgz
		tabix -p bed density.bgz
	>>>

	output {
		File density_starch = glob('density.starch')[0]
		File density_bw = glob('density.bw')[0]
		File density_bgz = glob('density.bgz')[0]
		File density_bgz_tbi = glob('density.bgz.tbi')[0]
	}

	runtime {
		cpu: 2
		memory: "32000 MB"
	}

}

task insert_sizes {
	File filtered_bam
	File nuclear_chroms

	command <<<
		picard CollectInsertSizeMetrics \
			INPUT=${filtered_bam} \
			OUTPUT=CollectInsertSizeMetrics.picard \
			HISTOGRAM_FILE=CollectInsertSizeMetrics.picard.pdf \
			VALIDATION_STRINGENCY=LENIENT \
			ASSUME_SORTED=true

		cat CollectInsertSizeMetrics.picard \
			| awk '/## HISTOGRAM/{x=1;next}x' \
			| sed 1d \
			> hist.txt

		python3 $STAMPIPES/scripts/utility/picard_inserts_process.py hist.txt > CollectInsertSizeMetrics.picard.info
	>>>

	output {
		Array[File] collect_insert_size_metrics = glob('CollectInsertSizeMetrics.picard*')
	}
}
