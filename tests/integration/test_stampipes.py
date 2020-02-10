import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_flag_qc_fail_improper_pair_and_nonnuclear_bam_reads')
def test_flag_qc_fail_improper_pair_and_nonnuclear_bam_reads_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/flagged.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/flagged.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())
