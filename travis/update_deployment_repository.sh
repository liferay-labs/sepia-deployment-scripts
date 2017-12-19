#!/usr/bin/env bash

set -euo pipefail

while getopts "c:" OPT; do
  case ${OPT} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

echo "CONFIG_DIR: ${CONFIG_DIR}"

set -o allexport
source ${CONFIG_DIR}/setup_deployment_pipeline.env
set +o allexport

printf "Values used: \n"
printf "COMMIT_MESSAGE_PREFIX: %s\n" "${COMMIT_MESSAGE_PREFIX}"
printf "DEPLOYMENT_ARTIFACTS_BRANCH: %s\n" "${DEPLOYMENT_ARTIFACTS_BRANCH}"
printf "DEPLOYMENT_ARTIFACTS_ORG: %s\n" "${DEPLOYMENT_ARTIFACTS_ORG}"
printf "DEPLOYMENT_ARTIFACTS_REPO: %s\n" "${DEPLOYMENT_ARTIFACTS_REPO}"
printf "DOCKER_IMAGE_NAME: %s\n" "${DOCKER_IMAGE_NAME}"
printf "DOCKER_IMAGE_VERSION: %s\n" "${DOCKER_IMAGE_VERSION}"
printf "DOCKER_ORG: %s\n" "${DOCKER_ORG}"
printf "\n"

# Echo commands with expanded variables
set -x

# Clone deployment repository
cd ${TRAVIS_BUILD_DIR}/..

git clone --depth=50 --branch=${DEPLOYMENT_ARTIFACTS_BRANCH} https://github.com/${DEPLOYMENT_ARTIFACTS_ORG}/${DEPLOYMENT_ARTIFACTS_REPO}.git

DEPLOYMENT_REPO_DIR=${TRAVIS_BUILD_DIR}/../${DEPLOYMENT_ARTIFACTS_REPO}

cd ${DEPLOYMENT_REPO_DIR}

# Update docker image version. Commit and push change.

jq '.containerDefinitions[0].image = "'${DOCKER_ORG}'/'${DOCKER_IMAGE_NAME}':'${DOCKER_IMAGE_VERSION}'"' ${DEPLOYMENT_REPO_DIR}/Dockerrun.aws.json|sponge ${DEPLOYMENT_REPO_DIR}/Dockerrun.aws.json

git add ${DEPLOYMENT_REPO_DIR}/Dockerrun.aws.json

git commit -m "${COMMIT_MESSAGE_PREFIX} DOCKER_IMAGE_VERSION: ${DOCKER_IMAGE_VERSION}. Trigger TRAVIS_COMMIT: ${TRAVIS_COMMIT}. TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}"

git push