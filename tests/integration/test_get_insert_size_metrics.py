import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_get_insert_size_metrics')
def test_get_insert_size_metrics_metrics_match(test_data_dir, workflow_dir, skip_lines_match):
    actual_metrics_path = workflow_dir / Path('test-output/nuclear.CollectInsertSizeMetrics.picard')
    expected_metrics_path = test_data_dir / Path('dnase/aggregation/expected/nuclear.CollectInsertSizeMetrics.picard')
    assert skip_lines_match(actual_metrics_path.as_posix(), expected_metrics_path.as_posix(), 5)
