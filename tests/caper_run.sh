#!/bin/bash

set -e

echo "Running cromwell $CROMWELL and image $DNASE_DOCKER_IMAGE_TAG"

if [[ $# -eq 1 ]]; then
    caper run $1 --docker $DNASE_DOCKER_IMAGE_TAG --cromwell $CROMWELL --options ./tests/cromwell_options.json
fi

if [[ $# -eq 2 ]]; then
    caper run $1 --docker $DNASE_DOCKER_IMAGE_TAG --cromwell $CROMWELL -i $2 --options ./tests/cromwell_options.json
fi

