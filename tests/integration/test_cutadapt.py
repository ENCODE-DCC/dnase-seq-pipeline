import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_trim_adapters_on_fastq_pair')
def test_trim_adapters_on_fastq_pair_trimstats_match(test_data_dir, workflow_dir, skip_lines_match):
    actual_trimstats_path = workflow_dir / Path('test-output/trimstats.txt')
    expected_trimstats_path = test_data_dir / Path('dnase/trimming/trimstats.txt')
    assert skip_lines_match(actual_trimstats_path.as_posix(), expected_trimstats_path.as_posix(), 9)
