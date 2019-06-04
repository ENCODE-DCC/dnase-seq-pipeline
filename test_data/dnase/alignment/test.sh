#!/bin/bash

set -e

here=$(dirname "$0")
cd "$here"

STAMPIPES=$PWD/../../..
export STAMPIPES
nextflow run "$STAMPIPES/processes/bwa/process_bwa_paired_trimmed.nf" \
  -profile test,docker \
  "$@"

# Verify
source ../../test_helper.sh

set +e
for f in "tagcounts.txt" "MarkDuplicates.picard" "CollectInsertSizeMetrics.picard" "subsample.r1.spot.out" ; do
  verify check_text_sorted "$f"
done

verify check_starch "density.bed.starch"

verify check_bam "filtered.bam"
verify check_bam "marked.bam"

echo "Testing completed successfully"
