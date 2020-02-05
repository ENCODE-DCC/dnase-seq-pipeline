import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_sort_bam_with_samtools')
def test_sort_bam_with_samtools_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/sorted.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/sorted.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())
