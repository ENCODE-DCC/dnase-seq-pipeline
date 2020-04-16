import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_make_references')
def test_make_references_chrombuckets_starches_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/chrom-buckets.chr22.75_20.bed.starch')
    expected_starch_path = test_data_dir / Path('dnase/chrombuckets/chrom-buckets.chr22.75_20.bed.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())
