#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":n:e:d:i:g:c:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIX="${OPTARG}"
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

echo "Read environment variables for environment"

EB_ENV_VARS=`cat ${CONFIG_DIR}/prereqs/eb/env-vars/env-vars-${ENVIRONMENT_SUFFIX}.cfg`

echo "EB_ENV_VARS: ${EB_ENV_VARS}"

PREVIOUS_DIR=$(pwd)

cd ${PATH_TO_DEPLOYMENT_ARTIFACTS_REPO}

echo "Create eb environment from directory: ${PATH_TO_DEPLOYMENT_ARTIFACTS_REPO}"

eb create \
	--instance_type ${INSTANCE_TYPE} \
	--cname ${APPLICATION_NAME}-${ENVIRONMENT_SUFFIX} \
	--envvars "${EB_ENV_VARS}" \
	--region ${REGION} \
	${APPLICATION_NAME}-${ENVIRONMENT_SUFFIX} \

cd ${PREVIOUS_DIR}

