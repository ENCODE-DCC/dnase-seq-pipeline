import pysam
import pytest

from pathlib import Path


@pytest.fixture
def test_data_dir():
    return Path('tests/data')


@pytest.mark.workflow(name='test_sort_bam_with_samtools')
def test_sort_bam_with_samtools_bams_match(test_data_dir, workflow_dir):
    actual_bam_path = workflow_dir / Path('test-output/sorted.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/sorted.bam')
    actual_sam = pysam.view(actual_bam_path.as_posix())
    expected_sam = pysam.view(expected_bam_path.as_posix())
    assert actual_sam == expected_sam
