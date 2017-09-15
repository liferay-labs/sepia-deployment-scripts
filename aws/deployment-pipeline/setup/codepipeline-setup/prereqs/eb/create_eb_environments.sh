#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":n:e:d:i:g:c:" OPT; do
  case ${OPT} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIXES="${OPTARG}"
    ;;
    d) PATH_TO_DEPLOYMENT_ARTIFACTS_REPO="${OPTARG}"
    ;;
    i) INSTANCE_TYPE="${OPTARG}"
    ;;
    g) REGION="${OPTARG}"
    ;;
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

IFS=$','

for ENVIRONMENT_SUFFIX in ${ENVIRONMENT_SUFFIXES}; do
  ${DIR}/create_eb_environment.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIX} \
	-d ${PATH_TO_DEPLOYMENT_ARTIFACTS_REPO} \
	-i ${INSTANCE_TYPE} \
	-g ${REGION} \
	-c ${CONFIG_DIR}
done
