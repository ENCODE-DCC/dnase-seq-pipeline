import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_add_mate_cigar_to_bam')
def test_sort_bam_with_samtools_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/mate_cigar.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/mate_cigar.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())
