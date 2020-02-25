# ENCODE DNase-seq pipeline

### Organization
The *wdl* folder is split up into:
* tasks
* subworkflows
* workflows

Tasks wrap generic command-line utilities. Subworkflows use one or more tasks to create DNase-seq-specific utilities. Workflows combine mutliple subworkflows into a conceptually useful unit of work for consumption by the end user.

The *tests* folder is split up into:
* unit
* integration
* functional

In general unit tests ensure proper wrapping of command-line utilities by tasks. We are only checking for proper syntax of the command that is run, not its output. Integration tests ensure proper combination of tasks in subworkflows. We are using test input data and comparing actual output with expected output. Functional tests are similar to integration tests but call workflow WDLs directly.


### Testing
We use pytest-workflow and Caper to run Cromwell and compare outputs. Usually we can compare md5sums using the pytest-workflow yml. However for binary files like BAM and starch we write custom comparisons (kept in the .py files) that first convert the ouputs to plain text. These are automattically run by pytest-workflow after outputs have been generated.

The tests can be run by calling `pytest` in the parent dnase-seq-pipeline folder.

Tests dependencies:
* Java
* Docker
* `pip install requirements.txt`
* `conda install bedops` or `apt-get install bedops` (https://bedops.readthedocs.io/en/latest/content/installation.html)

The script that runs Caper expects some environment variables:
* DNASE_DOCKER_IMAGE_TAG - docker image to run tests (e.g. https://quay.io/encode-dcc/dnase-seq-pipeline:template)
* CROMWELL - path to cromwell.jar (download from https://github.com/broadinstitute/cromwell/releases)
* WOMTOOL - path to womtool.jar (download from https://github.com/broadinstitute/cromwell/releases)
