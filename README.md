# ENCODE DNase-seq pipeline

### Organization
The *wdl* folder is split up into:
* tasks
* subworkflows
* workflows
* structs

Tasks wrap generic command-line utilities. Subworkflows use one or more tasks to create DNase-seq-specific utilities. Workflows combine mutliple subworkflows into a conceptually useful unit of work for consumption by the end user. Structs define the abstract groups of parameters and files that should be passed around together.

The *tests* folder is split up into:
* unit
* integration
* functional

In general unit tests ensure proper wrapping of command-line utilities by tasks. We are only checking for proper syntax of the command that is run, not its output. Integration tests ensure proper combination of tasks in subworkflows. We are using test input data and comparing actual output with expected output. Functional tests are similar to integration tests but call workflow WDLs directly.


### Testing
We use pytest-workflow and Caper to run Cromwell and compare outputs. Usually we can compare md5sums using the pytest-workflow yml. For example in *tests/integration/test_samtools.yml* the *test_build_fasta_index.wdl* is run and we can assert *chr22.fa.fai* is returned with a certain md5sum:
```
- name: test_build_fasta_index
  tags:
    - integration
  command: >-
      tests/caper_run.sh \
      tests/integration/wdl/test_build_fasta_index.wdl \
      tests/integration/json/test_build_fasta_index.json
  stdout:
    contains:
      - "samtools faidx chr22.fa"
  files:
      - path: "test-output/chr22.fa.fai"
        md5sum: d89b1fd70e1fe59b329a8346a59ffc03
      - path: "test-output/chr22.fa"
        md5sum: 69a750d5ed9490e0d1e707a43368ba86
```
However for binary files like BAM and starch that have nondeterministic md5sums we write custom comparisons (kept in the .py files) that first convert the ouputs to plain text. These are automatically run by pytest-workflow after outputs have been generated. For example in *tests/integration/test_samtools.yml* the *test_sort_bam_by_coordinate.wdl* is run and we assert *sorted.bam* is returned but don't check its md5sum:
```
- name: test_sort_bam_by_coordinate
  tags:
    - integration
  command: >-
      tests/caper_run.sh \
      tests/integration/wdl/test_sort_bam_by_coordinate.wdl \
      tests/integration/json/test_sort_bam_by_coordinate.json
  stdout:
    contains:
      - "samtools sort"
      - "-l 0"
      - "-@ 1"
      - "out.bam"
      - "sorted.bam"
    must_not_contain:
      - "-n"
  files:
      - path: "test-output/sorted.bam"
```
Then in *tests/integration/test_samtools.py* we run a Python function that is linked to the *test_sort_bam_by_coordinate* test and compares the *sorted.bam* with the expected *sorted.bam* as SAM files:
```
import pytest

from pathlib import Path


@pytest.mark.workflow(name='test_sort_bam_by_coordinate')
def test_sort_bam_by_coordinate_bams_match(test_data_dir, workflow_dir, bams_match):
    actual_bam_path = workflow_dir / Path('test-output/sorted.bam')
    expected_bam_path = test_data_dir / Path('dnase/alignment/sorted.bam')
    assert bams_match(actual_bam_path.as_posix(), expected_bam_path.as_posix())
```
Here *test_data_dir* is a pytest fixture aliasing the folder where we keep our expected data (i.e. *tests/data*), *workflow_dir* is a fixture aliasing the directory in which pytest-workflow runs the WDL and collects the outputs, and  *bams_match* is a fixture aliasing a function that opens both the BAMs as SAMs and compares:
```
import pysam


def compare_bams_as_sams(bam_path1, bam_path2):
    sam1 = pysam.view(bam_path1)
    sam2 = pysam.view(bam_path2)
    return sam1 == sam2
```

The tests can be run by calling `pytest` in the parent *dnase-seq-pipeline* folder.

Tests dependencies:
* Java
* Docker
* `pip install requirements.txt`
* `conda install bedops` or `apt-get install bedops` (https://bedops.readthedocs.io/en/latest/content/installation.html)

The script that runs Caper expects some environment variables:
* DNASE_DOCKER_IMAGE_TAG - docker image to run tests (e.g. https://quay.io/encode-dcc/dnase-seq-pipeline:template)
* CROMWELL - path to cromwell.jar (download from https://github.com/broadinstitute/cromwell/releases)
* WOMTOOL - path to womtool.jar (download from https://github.com/broadinstitute/cromwell/releases)
