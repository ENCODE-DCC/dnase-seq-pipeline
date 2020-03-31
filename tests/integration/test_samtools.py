import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_sort_bam_by_coordinate')
def test_sort_bam_by_coordinate_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/sorted.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/sorted.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_sort_bam_by_name')
def test_sort_bam_by_name_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/sorted.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/name_sorted.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_filter_bam_reads_with_nonnuclear_flag')
def test_filter_bam_reads_with_nonnuclear_flag_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/nuclear.bam')
    expected_bam_path = test_data_dir / Path('dnase/filtering/nonnuclear_flag_filtered.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_filter_bam_reads_with_qc_fail_flag')
def test_filter_bam_reads_with_qc_fail_flag_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/qc_fail_flag_filtered.bam')
    expected_bam_path = test_data_dir / Path('dnase/filtering/qc_fail_flag_filtered.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_get_first_read_in_pair_from_bam')
def test_get_first_read_in_pair_from_bam_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/first_in_pair.bam')
    expected_bam_path = test_data_dir / Path('dnase/filtering/first_in_pair.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())


@pytest.mark.workflow(name='test_merge_name_sorted_bams')
def test_merge_name_sorted_bams_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/merged.bam')
    expected_bam_path = test_data_dir / Path('dnase/merging/merged.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())
