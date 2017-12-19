#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:f:r:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    f) PIPELINE_EXISTS_FILE="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

PIPELINE_NAME=${APPLICATION_NAME}-deployment-pipeline

set +o pipefail

aws codepipeline list-pipelines --region ${REGION} |jq -r '.pipelines[].name' |grep -q "^${PIPELINE_NAME}$"




set -o pipefail

if [ $? -eq 0 ]; then
  echo "Codepipeline ${PIPELINE_NAME} exists"
  echo "Creating file ${PIPELINE_EXISTS_FILE}"
  touch ${PIPELINE_EXISTS_FILE}
fi
