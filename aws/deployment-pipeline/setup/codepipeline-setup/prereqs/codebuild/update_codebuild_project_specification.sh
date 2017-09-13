#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts "c:e:" opt; do
  case ${opt} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIX="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -o allexport
source ${CONFIG_DIR}/setup_deployment_pipeline.env
set +o allexport

set -x

PATH_TO_CODEBUILD_PROJECT_SPECIFICATION_FILE="${CONFIG_DIR}/prereqs/codebuild/codebuild-project-test-environment-${ENVIRONMENT_SUFFIX}.json"

jq '.environmentVariables[1].value = "http://'${APPLICATION_NAME}'-'${ENVIRONMENT_SUFFIX}'.'${REGION}'.elasticbeanstalk.com"' ${PATH_TO_CODEBUILD_PROJECT_SPECIFICATION_FILE}|sponge ${PATH_TO_CODEBUILD_PROJECT_SPECIFICATION_FILE}