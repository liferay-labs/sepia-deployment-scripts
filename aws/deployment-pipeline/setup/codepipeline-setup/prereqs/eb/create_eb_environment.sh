#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function cleanup {
  echo "Cleanup create_eb_environment temp files"
  rm -r ${EB_TEMP_DIR} || true
  rm ${DIR}/deployment-artifacts.zip || true
  rmdir ${DIR}/${DEPLOYMENT_ARTIFACTS_REPO}-${DEPLOYMENT_ARTIFACTS_BRANCH} || true
}
trap cleanup EXIT

while getopts ":n:e:o:r:b:i:g:c:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIX="${OPTARG}"
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

echo "Cleanup existing deployment artifacts"

EB_TEMP_DIR="${DIR}/eb_temp"

rm -r ${EB_TEMP_DIR} || true

mkdir -p ${EB_TEMP_DIR}


echo "Download and unzip deployment artifacts"

DEPLOYMENT_ARTIFACTS_URL=https://github.com/${DEPLOYMENT_ARTIFACTS_ORG}/${DEPLOYMENT_ARTIFACTS_REPO}/archive/${DEPLOYMENT_ARTIFACTS_BRANCH}.zip

wget ${DEPLOYMENT_ARTIFACTS_URL} -O ${DIR}/deployment-artifacts.zip

unzip -o ${DIR}/deployment-artifacts.zip

rm ${DIR}/deployment-artifacts.zip

shopt -s dotglob # for considering dot files (turn on dot files)

mv ${DEPLOYMENT_ARTIFACTS_REPO}-${DEPLOYMENT_ARTIFACTS_BRANCH}/* ${EB_TEMP_DIR}

rmdir ${DEPLOYMENT_ARTIFACTS_REPO}-${DEPLOYMENT_ARTIFACTS_BRANCH}


echo "Update EB Environment specifcation"

PATH_TO_EB_DOCKER_JSON_FILE=${EB_TEMP_DIR}/Dockerrun.aws.json

${DIR}/update_eb_environment_specification.sh \
	-c ${CONFIG_DIR} \
	-p ${PATH_TO_EB_DOCKER_JSON_FILE}

echo "Read environment variables for environment"

EB_ENV_VARS=`cat ${CONFIG_DIR}/prereqs/eb/env-vars/env-vars-${ENVIRONMENT_SUFFIX}.cfg`

echo "EB_ENV_VARS: ${EB_ENV_VARS}"

PREVIOUS_DIR=$(pwd)

cd ${EB_TEMP_DIR}

echo "Create eb environment from directory: ${EB_TEMP_DIR}"

eb create \
	--instance_type ${INSTANCE_TYPE} \
	--cname ${APPLICATION_NAME}-${ENVIRONMENT_SUFFIX} \
	--envvars "${EB_ENV_VARS}" \
	--region ${REGION} \
	${APPLICATION_NAME}-${ENVIRONMENT_SUFFIX} \

cd ${PREVIOUS_DIR}

