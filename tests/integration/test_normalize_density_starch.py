import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_normalize_density_starch')
def test_normalize_density_starches_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/normalized.nuclear.density.starch')
    expected_starch_path = test_data_dir / Path('dnase/normalizing/normalized.nuclear.density.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())
