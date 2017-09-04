#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":c:" opt; do
  case ${opt} in
    c) CONFIG_DIR="${OPTARG}"
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

IFS=$','

for ENVIRONMENT_SUFFIX in ${ENVIRONMENT_SUFFIXES}; do
  ${DIR}/update_codebuild_project_specification.sh \
	-e ${ENVIRONMENT_SUFFIX} \
	-c ${CONFIG_DIR}
done
