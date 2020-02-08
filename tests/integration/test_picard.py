import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_add_mate_cigar_to_bam')
def test_add_mate_cigar_to_bam_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/mate_cigar.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/mate_cigar.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_mark_duplicates_in_bam_and_get_duplication_metrics')
def test_mark_duplicates_in_bam_and_get_duplication_metrics_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/marked.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/marked.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_mark_duplicates_in_bam_and_get_duplication_metrics')
def test_mark_duplicates_in_bam_and_get_duplication_metrics_metrics_match(test_data_dir, workflow_dir, skip_lines_match):
    actual_metrics_path = workflow_dir / Path('test-output/MarkDuplicates.picard')
    expected_metrics_path = test_data_dir / Path('dnase/alignment/MarkDuplicates.picard')
    assert skip_lines_match(actual_metrics_path.as_posix(), expected_metrics_path.as_posix(), 5)
