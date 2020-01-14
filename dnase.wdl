workflow dnase {
    Array[File] fastqs
    Boolean UMI
    String? UMI_value
    Boolean dofeatures
    Boolean domotifs
    Boolean fastqs_only = true# temporary flag to run alignment only
    File? hotspot_index
    File? bias
    File adapters
    File mappable
    File chrom_info
    File chrom_bucket
    File nuclear_chroms
    File reference_index
    File reference
    Int read_length
    Int split_fastq_chunksize
    Int trim_to = 0
    Int threads = 1

    scatter (i in range(length(fastqs))) {
        call split_fastq { input:
            fastq = fastqs[i],
            fastq_line_chunks = 4 * split_fastq_chunksize,
            read_number = i + 1
        }
    }

    Array[Pair[File, File]] chunked_pairs = zip(split_fastq.splits[0], split_fastq.splits[1])

    scatter (pair in chunked_pairs) {
        call trim_adapters { input:
            read_one = pair.left,
            read_two = pair.right,
            adapters = adapters,
            threads = threads
        }

        if (trim_to > 0) {
            call trim_to_length { input:
                read_one = trim_adapters.trimmed_fastqs[0],
                read_two = trim_adapters.trimmed_fastqs[1],
                trim_to = trim_to
            }
        }

        Array[File] trimmed_fastqs = select_first([trim_to_length.trimmed_fastqs, trim_adapters.trimmed_fastqs])

        if (UMI) {
            call add_umi_info { input:
                read_one = trimmed_fastqs[0],
                read_two = trimmed_fastqs[1],
                UMI_value = UMI_value
            }
        }

        Array[File] fastqs_for_alignment = select_first([add_umi_info.with_umi, trimmed_fastqs])

        call align { input:
            read_one = fastqs_for_alignment[0],
            read_two = fastqs_for_alignment[1],
            reference = reference,
            reference_index = reference_index,
            threads = threads
        }

        call filter_bam { input:
            unfiltered_bam = align.unfiltered_bam,
            nuclear_chroms = nuclear_chroms
        }

        call sort_bam { input:
            filtered_bam = filter_bam.filtered_bam,
            threads = threads
        }
    }

    call merge { input:
        bams = sort_bam.sorted_bam
    }

    String dups_cmd =   if UMI then 'UmiAwareMarkDuplicatesWithMateCigar' 
                               else 'MarkDuplicatesWithMateCigar'
    String dups_extra = if UMI then 'UMI_TAG_NAME=XD'
                               else '' 
    call dups { input:
        merged_bam = merge.merged_bam,
        cmd = dups_cmd,
        extra = dups_extra
    }

    Int flag = if UMI then 1536 else 512

    call filter { input:
        marked_bam = dups.marked_bam,
        flag = flag
    }

    call bam_counts { input:
        marked_bam = dups.marked_bam
    }

    call count_adaptors { input:
        marked_bam = dups.marked_bam
    }

    call hotspot2 { input:
        filtered_bam = filter.filtered_bam,
        mappable = mappable
    }

    call make_intervals { input:
        hotspot_calls = hotspot2.hotspot_calls
    }

    if ( dofeatures ) {
        call closest_features { input:
            hotspot_calls = hotspot2.hotspot_calls,

        }
    }

    if ( defined( hotspot_index ) ) {
        call differential_hotspots { input:
            marked_bam = dups.marked_bam,
            onepercent_peaks = hotspot2.onepercent_peaks,
            index = hotspot_index
        }
    }

    call spot_score { input:
        filtered_bam = filter.filtered_bam,
        mappable = mappable,
        chrom_info = chrom_info,
        read_length = read_length
    }

    call cutcounts { input:
        filtered_bam = filter.filtered_bam,
        reference_index = reference_index
    }

    call density { input:
        filtered_bam = filter.filtered_bam,
        chrom_bucket = chrom_bucket,
        reference_index = reference_index
    }

    call normalize_density { input:
        filtered_bam = filter.filtered_bam,
        density = density.density_starch,
        reference_index = reference_index
    }

    call insert_sizes { input:
        filtered_bam = filter.filtered_bam,
        nuclear_chroms = nuclear_chroms
    }

    call filter_nuclear { input:
        filtered_bam = filter.filtered_bam,
        nuclear_chroms = nuclear_chroms
    }

    call preseq { input:
        nuclear_bam = filter_nuclear.nuclear_bam
    }

    if ( defined( bias )) {
        call learn_dispersion { input:
            filtered_bam = filter.filtered_bam,
            spots = hotspot2.hotspot_calls,
            reference = reference,
            bias = bias
        }
    }

    output {

    }
}

task split_fastq {
    File fastq
    Int fastq_line_chunks
    Int read_number


    command {
        zcat ${fastq} \
            | split -l ${fastq_line_chunks} \
            --filter='gzip -1 > $FILE.gz' - 'split_r${read_number}'
    }

    output {
        Array[File] splits = glob('split_*gz')
    }
}

task trim_adapters {
    File read_one
    File read_two
    File adapters
    Int threads

    command <<<
        trim-adapters-illumina \
            -f ${adapters} \
            -1 P5 -2 P7 \
            --threads=${threads} \
            ${read_one} \
            ${read_two}  \
            "trim.R1.fastq.gz" \
            "trim.R2.fastq.gz" \
            &> trimstats.txt

        awk '{print "adapter-trimmed\t" $NF * 2}' \
            < trimstats.txt \
            > trim.counts.txt
    >>>

    output {
        Array[File] trimmed_fastqs = glob('trim*fastq.gz')
        File trim_counts = glob('trim.counts.txt')[0]
    }
}

task trim_to_length {
    File read_one
    File read_two
    Int trim_to

    command <<<
        zcat ${read_one} | awk 'NR%2==0 {print substr($0, 1, ${trim_to})} NR%2!=0' | gzip -c -1 > r1.trim.fastq.gz
        zcat ${read_two} | awk 'NR%2==0 {print substr($0, 1, ${trim_to})} NR%2!=0' | gzip -c -1 > r2.trim.fastq.gz

    >>>

    output {
        Array[File] trimmed_fastqs = glob('*trim.fastq.gz')
    }

}

task add_umi_info {
    File read_one
    File read_two
    String UMI_value

    command {
        UMI=${UMI_value}
        if [ UMI -eq 'thruplex' ]
        then 
            python3 $STAMPIPES/scripts/umi/extract_umt.py \
                <(zcat ${read_one}) \
                <(zcat ${read_two}) \
                >(gzip -c -1 > r1.fastq.umi.gz) \
                >(gzip -c -1 > r2.fastq.umi.gz)
        elif [UMI -eq 'True']
        then
            python3 $STAMPIPES/scripts/umi/fastq_umi_add.py ${read_one} r1.fastq.umi.gz
            python3 $STAMPIPES/scripts/umi/fastq_umi_add.py ${read_two} r2.fastq.umi.gz
        fi
    }

    output {
        Array[File] with_umi = glob('*.fastq.umi.gz')
    }
}

task align {
    File read_one
    File read_two
    File reference
    File reference_index

    File amb
    File ann
    File bwt
    File pac
    File sa 

    Int threads

    command {
        ln ${amb} . && ln ${ann} . && ln ${bwt} . && ln ${pac} . && ln ${sa} .
        bwa aln \
            -Y -l 32 -n 0.04 \
            -t ${threads} \
            ${reference} \
            ${read_one} \
            > out1.sai

        bwa aln \
            -Y -l 32 -n 0.04 \
            -t ${threads} \
            ${reference} \
            ${read_two} \
            > out2.sai

        bwa sampe \
            -n 10 -a 750 \
            ${reference} \
            out1.sai out2.sai \
            ${read_one} ${read_two} \
            | samtools view -b -t ${reference_index} - \
            > out.bam
    }

    output {
        File unfiltered_bam = glob('out.bam')[0]
    }
}

task filter_bam {
    File unfiltered_bam
    File nuclear_chroms

    command {
        python3 $STAMPIPES/scripts/bwa/filter_reads.py \
            ${unfiltered_bam} \
            filtered.bam \
            ${nuclear_chroms}
    }

    output {
        File filtered_bam = glob('filtered.bam')[0]
    }
}

task sort_bam {
    File filtered_bam
    Int threads

    command {
        samtools sort \
            -l 0 -m 1G -@ ${threads} ${filtered_bam} \
            > sorted.bam
    }

    output {
        File sorted_bam = glob('sorted.bam')[0]
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
        File marked_bam =        glob('marked.bam')[0]
        File marked_bam_bai =    glob('marked.bam.bai')[0]
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


task make_intervals {
    File hotspot_calls
    Int chunksize

    command {
        unstarch ${hotspot_calls} \
            | grep -v "_random" \
            | grep -v "chrUn" \
            | grep -v "chrM" \
            | split -l ${chunksize} -a 4 -d - chunk_
    }

    output {
        Array[File] intervals = glob('chunk_*')
    }

}

task closest_features {
    File hotspot_calls
    File transcript_starts
    String thresholds

    command <<<
        closest-features \
            --dist \
            --delim '\t' \
            --closest \
            ${hotspot_calls} \
            ${transcript_starts} \
            > closest.txt
        
        cat closest.txt \
            | grep -v "NA$" \
            | awk -F"\t" '{print $NF}' \
            | sed -e 's/-//g' \
            > closest.clean.txt

        for t in $thresholds ; do
            awk \
            -v t=$t \
            '$1 > t {sum+=1} END {print "percent-proximal-" t "bp " sum/NR}' \
            closest.clean.txt \
            >> prox_dist.info
        done
    >>>

    output {
        File prox_dist_info = glob('prox_dist.info')[0]
    }
}

task motif_matrix {
    File hotspot_calls
    File fimo_transfac
    File fimo_names

    command {
        bedmap --echo --echo-map-id --fraction-map 1 --delim '\t' ${hotspot_calls} ${fimo_transfac} > temp.bedmap.txt
        python $STAMPIPES/scripts/bwa/aggregate/basic/sparse_motifs.py ${fimo_names} temp.bedmap.txt
    }

    output {
        Array[File] hs_motifs = glob('hs_motifs*.txt')
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
    File reference_index

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
            ${reference_index}

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
    File reference_index
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
            ${reference_index} \
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
        cpu: 8
        memory: "32000 MB"
    }

}

task normalize_density {
    File filtered_bam
    File density
    File reference_index

    Int bin_size = 20
    String scale = '1_000_000'


    command <<<
        unstarch ${density} \
            | awk -v allcounts=$(samtools view -c ${filtered_bam}) \
            -v extranuclear_counts=$(samtools view -c ${filtered_bam} chrM chrC) \
            -v scale=${scale} \
            'BEGIN{ tagcount=allcounts-extranuclear_counts }
            { z=$5;
            n=(z/tagcount)*scale;
            print $1 "\t" $2 "\t" $3 "\t" $4 "\t" n }' \
            | starch - > normalized.density.starch

        $STAMPIPES/scripts/bwa/starch_to_bigwig.bash \
            normalized.density.starch \
            normalized.density.bw \
            ${reference_index} \
            ${bin_size}

        unstarch normalized.density.starch | bgzip > normalized.density.bgz
        tabix -p bed normalized.density.bgz
    >>>


    output {
        File normalized_density_starch = glob('normalized.density.starch')[0]
        File normalized_density_bw = glob('normalized.density.bw')[0]
        File normalized_density_bgz = glob('normalized.density.bgz')[0]
        File normalized_density_bgz_tbi = glob('normalized.density.bgz.tbi')[0]
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

task filter_nuclear {
    File filtered_bam
    File nuclear_chroms

    command {
        samtools index ${filtered_bam}
        cat ${nuclear_chroms} \
            | xargs samtools view -b ${filtered_bam} \
            > nuclear.bam
    }

    output {
        File nuclear_bam = glob('nuclear.bam')[0]
    }
}

task preseq {
    File nuclear_bam

    command {
        python3 $STAMPIPES/scripts/bam/mark_dups.py -i ${nuclear_bam} -o /dev/null --hist dups.hist
        preseq lc_extrap -hist dups.hist -extrap 1.001e9 -s 1e6 -v > preseq.txt \
        || preseq lc_extrap -defects -hist dups.hist -extrap 1.001e9 -s 1e6 -v > preseq.txt

        # write out preseq targets
        bash $STAMPIPES/scripts/utility/preseq_targets.sh preseq.txt preseq_targets.txt
    }

    output {
        File preseq_txt = glob('preseq.txt')[0]
        File preseq_targets = glob('preseq_targets.txt')[0]
        File dups_hist = glob('dups.hist')[0]
    }
}

task learn_dispersion {
    File filtered_bam
    File reference
    File spots
    File bias

    command {
        samtools index ${filtered_bam}

        # TODO: Use nuclear file
        unstarch ${spots} \
            | grep -v "_random" \
            | grep -v "chrUn" \
            | grep -v "chrM" \
            > intervals.bed

        ftd-learn-dispersion-model \
            --bm ${bias} \
            --half-win-width 5 \
            --processors 8 \
            ${filtered_bam} \
            ${reference} \
            intervals.bed \
            > dm.json
    }

    output {
        File to_plot = glob('dm.json')[0]
        File filtered_bam_indexed = glob('filtered.bam.bai')[0]
    }

    runtime {
        cpu: 8
        memory: "8000 MB"
    }
}




