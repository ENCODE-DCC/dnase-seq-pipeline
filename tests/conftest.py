import pytest
import sys

from pathlib import Path


sys.path.append(Path('tests/py').as_posix())


@pytest.fixture
def test_data_dir():
    return Path('tests/data')


@pytest.fixture
def bams_match():
    from comparisons import compare_bams_as_sams
    return compare_bams_as_sams


@pytest.fixture
def skip_lines_match():
    from comparisons import skip_n_lines_and_compare
    return skip_n_lines_and_compare


@pytest.fixture
def starches_match():
    from comparisons import compare_starches_as_beds
    return compare_starches_as_beds
