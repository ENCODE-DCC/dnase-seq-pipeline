import pytest

from pathlib import Path


@pytest.mark.workflow(name="test_flag_qc_fail_improper_pair_and_nonnuclear_bam_reads")
def test_flag_qc_fail_improper_pair_and_nonnuclear_bam_reads_bams_match(
    test_data_dir, workflow_dir, bams_match
):
    actual_bam_path = workflow_dir / Path("test-output/flagged.bam")
    expected_bam_path = test_data_dir / Path("dnase/alignment/flagged.bam")
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name="test_get_chrombuckets")
def test_flag_qc_fail_improper_pair_and_nonnuclear_bam_reads_bams_match(
    test_data_dir, workflow_dir, starches_match
):
    actual_starch_path = workflow_dir / Path("test-output/chrom-buckets.chr22.75_20.bed.starch")
    expected_starch_path = test_data_dir / Path("dnase/chrombuckets/chrom-buckets.chr22.75_20.bed.starch")
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())
