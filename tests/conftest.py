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
