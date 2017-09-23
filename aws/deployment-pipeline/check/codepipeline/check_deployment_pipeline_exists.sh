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

LIST_PIPELINE_OUTPUT=`aws codepipeline list-pipelines --region ${REGION} |jq -r '.pipelines[].name' |{ grep "^${PIPELINE_NAME}$" || true; }`

if [ ! -z "$LIST_PIPELINE_OUTPUT" ]; then
  echo "Codepipeline ${PIPELINE_NAME} exists in region ${REGION}"
  echo "Creating file ${PIPELINE_EXISTS_FILE}"
  touch ${PIPELINE_EXISTS_FILE}
else
  echo "Codepipeline ${PIPELINE_NAME} does not exist in region ${REGION}"
fi
