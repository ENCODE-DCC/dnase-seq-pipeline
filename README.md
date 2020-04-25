# ENCODE DNase-seq pipeline

### Introduction
This is the uniform processing pipeline for [ENCODE DNase-seq experiments](https://www.encodeproject.org/search/?type=Experiment&assay_title=DNase-seq). It uses [WDL](https://github.com/openwdl/wdl) and [Caper](https://github.com/ENCODE-DCC/caper) (a wrapper over [Cromwell](https://github.com/broadinstitute/cromwell)) to specify and run the processing steps, and [Docker](https://www.docker.com/) to ensure a reproducible and portable compute environment. The same inputs should produce the same outputs regardless of computational platform (local, Cloud, etc.). The benefits of having a reproducible workflow include generating processed results that are comparable between ENCODE experiments and providing outside users an easy way to process their own DNAse-seq data for comparison with ENCODE data.

### Quickstart
Assuming the requirements are installed you must create a JSON file specifying the inputs of the pipeline. These include the raw FASTQs from the DNase-seq experiment as well as reference files specific to an assembly (e.g. GRCh38) and read length (e.g. 76bp). There are three sections in the input JSON:

```
{
    "dnase.replicates": [],
    "dnase.references": {},
    "dnase.machine_sizes": {}
}
```

`dnase.replicates` takes a list of biological replicates. Here's an example of how to specify the input for [ENCSR693UHT](https://www.encodeproject.org/experiments/ENCSR693UHT/), which has a single replicate and two paired-end FASTQs (where `R1` and `R2` specify the pair):

```
"dnase.replicates": [
    {
        "accession": "ENCSR693UHT",
        "number": "1",
        "read_length": "76",
        "adapters": {
            "file": "gs://dnase/ref/adapters.txt",
            "adapter1": "N707_P5",
            "adapter2": "N707_P7"
        },
        "pe_fastqs": [
            {
                "R1": "s3://encode-public/2019/08/21/af5c625b-b188-4b17-9e78-5463a60d0336/ENCFF201UOC.fastq.gz",
                "R2": "s3://encode-public/2019/08/21/a1ecf95f-713c-4890-95a1-88014b69ef2f/ENCFF149BGS.fastq.gz"
            },
            {
                "R1": "s3://encode-public/2019/08/21/766fecd1-258e-4a92-b725-7fdb6aa77a07/ENCFF752UBC.fastq.gz",
                "R2": "s3://encode-public/2019/08/21/87400548-896f-4b1e-921f-73127a9db3e2/ENCFF559DWT.fastq.gz"
            }
        ]
    }
]
```
Note that the adapter prefix (i.e. `N707`) corresponds to the flowcell barcode of the FASTQs and usually has `_P5` or `_P7` appended.

Here's how to specify the input for a 36bp single-end experiment with one replicate like [ENCSR420RWU](https://www.encodeproject.org/experiments/ENCSR420RWU/):
```
"dnase.replicates": [
    {
        "accession": "ENCSR420RWU",
        "number": "1",
        "read_length": "36",
        "se_fastqs": [
            "s3://encode-public/2014/07/04/580edf6f-10a4-4b42-b4a2-4f64a9a87901/ENCFF002DYE.fastq.gz",
            "s3://encode-public/2014/07/04/f123c3c1-3542-4eda-b2d0-7d789f95cea0/ENCFF002DYD.fastq.gz"
        ]
    }
]
```
Note that `adapters` aren't required for single-end experiments.

Here's how to specify the input for a 36bp mixed single-end/paired-end experiment with two replicates like [ENCSR426IEA](https://www.encodeproject.org/experiments/ENCSR426IEA/):
```
"dnase.replicates": [
    {
        "accession": "ENCSR426IEA",
        "number": "1",
        "read_length": "36",
        "adapters": {
            "file": "gs://dnase/ref/adapters.txt",
            "adapter1": "L2V9DR-BC16_P5",
            "adapter2": "L2V9DR-BC16_P7"
        },
        "pe_fastqs": [
             {
                 "R1": "s3://encode-public/2014/09/27/8a44e7ad-7586-49bd-ad62-6933981fdb17/ENCFF178WLB.fastq.gz",
                 "R2": "s3://encode-public/2014/09/27/2059b738-4e97-4553-a93b-3a112fc34969/ENCFF645INN.fastq.gz"
             },
             {
                 "R1": "s3://encode-public/2014/09/27/cd94b937-c67b-4b54-8b2e-13ab75ad0608/ENCFF377AOZ.fastq.gz",
                 "R2": "s3://encode-public/2014/09/27/0699c990-5072-42d2-9d70-10711853f487/ENCFF536KHM.fastq.gz"
             },
             {
                 "R1": "s3://encode-public/2014/09/27/86a8a345-7c10-4789-9e7a-ca73fc7160e3/ENCFF665FKP.fastq.gz",
                 "R2": "s3://encode-public/2014/09/27/d0631a63-ea91-4c48-a2ec-c93fe4cd72a4/ENCFF580MND.fastq.gz"
             },
             {
                 "R1": "s3://encode-public/2014/09/27/a60a7b84-d9da-48a7-be29-dbaa7a0094be/ENCFF901FSW.fastq.gz",
                 "R2": "s3://encode-public/2014/09/27/96561da6-f942-492b-909f-94a1ad48cea6/ENCFF719IMH.fastq.gz"
             }
         ],
         "se_fastqs": [
             "s3://encode-public/2014/09/27/323b2f10-1ea9-44e6-b366-e6dc0cfd7006/ENCFF302JOP.fastq.gz"
         ]
    },
    {
        "accession": "ENCSR426IEA",
        "number": "2",
        "read_length": "36",
        "adapters": {
            "file": "gs://dnase/ref/adapters.txt",
            "adapter1": "AD027_P5",
            "adapter2": "AD027_P7"
        },
        "pe_fastqs": [
            {
                "R1": "s3://encode-public/2014/09/27/a4c088cb-654f-4bb8-8d74-20301711b67b/ENCFF266WWA.fastq.gz",
                "R2": "s3://encode-public/2014/09/27/0760ec09-c0e9-4c5b-a970-52c17d062e2a/ENCFF314WHE.fastq.gz"
            }
        ],
        "se_fastqs": [
            "s3://encode-public/2014/09/27/9cf1e90b-e2a6-41dc-bbb6-2aaaefcb9d83/ENCFF355JSW.fastq.gz"
        ]
    }
]
```

`dnase.references` takes read-length specialized reference files for Hotspot1/Hotspot2 steps, as well as standard genomic indices required by the pipeline:
```
"dnase.references": {
    "genome_name": "GRCh38",
    "indexed_fasta": {
        "fasta": "gs://dnase/ref/GRCh38.fa",
        "fai": "gs://dnase/ref/GRCh38.fa.fai"
    },
    "bwa_index": {
        "bwt": "gs://dnase/ref/GRCh38.fa.bwt",
        "fasta": "gs://dnase/ref/GRCh38.fa",
        "pac": "gs://dnase/ref/GRCh38.fa.pac",
        "ann": "gs://dnase/ref/GRCh38.fa.ann",
        "amb": "gs://dnase/ref/GRCh38.fa.amb",
        "sa": "gs://dnase/ref/GRCh38.fa.sa"
    },
    "nuclear_chroms": "gs://dnase/ref/nuclear_chroms.txt",
    "narrow_peak_auto_sql": "gs://dnase/ref/bigbed/narrowPeak.as",
    "hotspot1": {
        "chrom_info": "gs://dnase/ref/GRCh38.chromInfo.bed",
        "mappable_regions": "gs://dnase/ref/36/GRCh38.K36.mappable_only.bed"
    },
    "hotspot2": {
        "chrom_sizes": "gs://dnase/ref/GRCh38.chrom_sizes.bed",
        "center_sites": "gs://dnase/ref/36/GRCh38.K36.center_sites.n100.starch",
        "mappable_regions": "gs://dnase/ref/36/GRCh38.K36.mappable_only.bed"
    }
```
In most cases references should already exist for a given assembly/read length, though the `references.wdl` workflow can be used to generate most of these for a new assembly/read length. Note that it is important for the `genome_name` to corresponds to the prefix of your references/indices.

`dnase.machine_sizes` specifies the desired compute size for specific steps of the pipeline (when custom instances can be specified).
```
"dnase.machine_sizes": {
    "align": "large2x",
    "concatenate": "medium",
    "convert": "medium",
    "filter": "large",
    "mark": "large",
    "merge": "large",
    "normalize": "medium2x",
    "peaks": "medium",
    "qc": "medium",
    "score": "medium",
    "trim": "large2x"
}
```

The sizes are defined in [wdl/runtimes.json](wdl/runtimes.json). For example `medium` corresponds to these resources:
```
"medium": {
    "cpu": 2,
    "memory_gb": 4,
    "disks": "local-disk 50 SSD"
}
```
Note that specifying `dnase.machine_sizes` is optional and default values from [wdl/default_machine_sizes.json](wdl/default_machine_sizes.json) will be used if it is not specified in the input JSON.

You can use the 76bp [dnase_template.json](templates/json/GRCh38/76/dnase_template.json) or the 36bp [dnase_template.json](templates/json/GRCh38/36/dnase_template.json) for GRCh38 to avoid having to fill in the references and machine_size sections.

### Steps
The pipelines can be roughly split up into these steps:
* *Concatenate, trim, and align fastqs* - The raw FASTQs are concatenated, trimmed for adapters and length, and aligned with BWA (single-end and paired-end data are kept separate).
* *Merge, mark, and filter BAMs* - The aligned PE/SE BAMs are merged, duplicates, low-quality, and non-nuclear reads are marked and filtered out.
* *Call hotspots and peaks and get SPOT score* - The BAM is passed to Hotspots1 and Hotspot2 in order to get peaks and SPOT score.
* *Calculate and gather QC* - Various quality metrics such as `samtools flagstats` are collected.
* *Normalize and convert files* - The `density starch` from Hotspot2 is normalized and converted to a `bigWig`, peak `starches` are converted to `bed` and `bigBed` format.


### Running with Caper

Once the input JSON has been specified and placed somewhere accessible (e.g in a Google Cloud bucket) you can launch the workflow:

```
caper submit dnase.wdl --inputs gs://dnase/json/ENCSR426IEA.json --docker $DNASE_DOCKER_IMAGE_TAG
```
Note that `$DNASE_DOCKER_IMAGE_TAG` is an environment variable specifying a link to our Docker image on Quay.

You can check on the status of the workflow with:
```
caper list --hide-subworkflow
```

### Outputs
**Files**
* unfiltered_bam
* nuclear_bam
* normalized_density_bw
* five_percent_allcalls_bed_gz
* five_percent_allcalls_bed_bigbed
* five_percent_narrowpeaks_bed_gz
* five_percent_narrowpeaks_bigbed
* tenth_of_one_percent_narrowpeaks_bed_gz
* tenth_of_one_percent_narrowpeaks_bigbed

**Quality Metrics**
unfiltered_bam:
* trimstats
* stats
* flagstats
* bamcounts

nuclear_bam:
* stats
* flagstats
* hotspot1 spot_score
* duplication_metrics
* preseq
* preseq_targets
* insert_size_metrics
* insert_size_info
* insert_size_histogram_pdf

(Note that insert sizes and trimstats only included for PE data.)

peaks:
* hotspot2 spot_score

### Repository Organization
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
* `conda install bedops` or `brew install bedops` (https://bedops.readthedocs.io/en/latest/content/installation.html)

The script that runs Caper expects some environment variables:
* DNASE_DOCKER_IMAGE_TAG - docker image to run tests (e.g. https://quay.io/encode-dcc/dnase-seq-pipeline:template)
* CROMWELL - path to cromwell.jar (download from https://github.com/broadinstitute/cromwell/releases)
* WOMTOOL - path to womtool.jar (download from https://github.com/broadinstitute/cromwell/releases)
        
