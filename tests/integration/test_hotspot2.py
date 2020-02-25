import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_call_peaks_with_hotspot2')
def test_call_peaks_with_hotspot2_hotspots_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/filtered.0.05.hotspots.fdr0.05.starch')
    expected_starch_path = test_data_dir / Path('dnase/hotspot2/expected/filtered.0.05.hotspots.fdr0.05.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())


@pytest.mark.workflow(name='test_call_peaks_with_hotspot2')
def test_call_peaks_with_hotspot2_peaks_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/filtered.0.05.peaks.starch')
    expected_starch_path = test_data_dir / Path('dnase/hotspot2/expected/filtered.0.05.peaks.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())


@pytest.mark.workflow(name='test_call_peaks_with_hotspot2')
def test_call_peaks_with_hotspot2_narrowpeaks_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/filtered.0.05.peaks.narrowpeaks.starch')
    expected_starch_path = test_data_dir / Path('dnase/hotspot2/expected/filtered.0.05.peaks.narrowpeaks.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())


@pytest.mark.workflow(name='test_call_peaks_with_hotspot2')
def test_call_peaks_with_hotspot2_densities_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/filtered.0.05.density.starch')
    expected_starch_path = test_data_dir / Path('dnase/hotspot2/expected/filtered.0.05.density.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())


@pytest.mark.workflow(name='test_call_peaks_with_hotspot2')
def test_call_peaks_with_hotspot2_cutcounts_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/filtered.0.05.cutcounts.starch')
    expected_starch_path = test_data_dir / Path('dnase/hotspot2/expected/filtered.0.05.cutcounts.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())


@pytest.mark.workflow(name='test_call_peaks_with_hotspot2')
def test_call_peaks_with_hotspot2_allcalls_match(test_data_dir, workflow_dir, starches_match):
    actual_starch_path = workflow_dir / Path('test-output/filtered.0.05.allcalls.starch')
    expected_starch_path = test_data_dir / Path('dnase/hotspot2/expected/filtered.0.05.allcalls.starch')
    assert starches_match(actual_starch_path.as_posix(), expected_starch_path.as_posix())
