#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":n:e:s:c:r:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIXES="${OPTARG}"
    ;;
    s) SERVICE_ROLE_ARN="${OPTARG}"
    ;;
    c) CONFIG_DIR="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

IFS=$','

for ENVIRONMENT_SUFFIX in ${ENVIRONMENT_SUFFIXES}; do
  ${DIR}/create_codebuild_project.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIX} \
	-s ${SERVICE_ROLE_ARN} \
	-c ${CONFIG_DIR} \
	-r ${REGION}
done
