#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":n:e:o:r:b:i:g:c:" OPT; do
  case ${OPT} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIXES="${OPTARG}"
    ;;
    o) DEPLOYMENT_ARTIFACTS_ORG="${OPTARG}"
    ;;
    r) DEPLOYMENT_ARTIFACTS_REPO="${OPTARG}"
    ;;
    b) DEPLOYMENT_ARTIFACTS_BRANCH="${OPTARG}"
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
	-o ${DEPLOYMENT_ARTIFACTS_ORG} \
	-r ${DEPLOYMENT_ARTIFACTS_REPO} \
	-b ${DEPLOYMENT_ARTIFACTS_BRANCH} \
	-i ${INSTANCE_TYPE} \
	-g ${REGION} \
	-c ${CONFIG_DIR}
done
