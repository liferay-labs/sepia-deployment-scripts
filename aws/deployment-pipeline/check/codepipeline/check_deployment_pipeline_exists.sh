#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:f:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    f) PIPELINE_EXISTS_FILE="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

PIPELINE_NAME=${APPLICATION_NAME}-deployment-pipeline

(
	aws codepipeline get-pipeline --name ${PIPELINE_NAME}
)

if [ $? = 255 ]
then
  echo "Codepipeline ${PIPELINE_NAME} does not exist"
  exit 0
fi

if [ $? = 0 ]
then
  echo "Codepipeline ${PIPELINE_NAME} exists"
  echo "Creating file ${PIPELINE_EXISTS_FILE}"
  touch ${PIPELINE_EXISTS_FILE}
  exit 0
fi

echo "Could not determine if codepipeline ${PIPELINE_NAME} exists"
exit 1
