#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATH_TO_ENV_FILE="${DIR}/update_deployment_repository.env"

while getopts ":p:c:v:i:" opt; do
  case ${opt} in
    p) PATH_TO_ENV_FILE="${OPTARG}"
    ;;
    c) componentName="${OPTARG}"
    ;;
    i) dockerImageName="${OPTARG}"
    ;;
    v) dockerImageVersion="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

. ${PATH_TO_ENV_FILE}

printf "Parameters: \n"
printf "componentName: %s\n" "${componentName}"
printf "dockerImageName: %s\n" "${dockerImageName}"
printf "dockerImageVersion: %s\n" "${dockerImageVersion}"
printf "\n"

printf "Env variables: \n"
printf "COMPONENT_NAME: %s\n" "${COMPONENT_NAME}"
printf "DOCKER_IMAGE_NAME: %s\n" "${DOCKER_IMAGE_NAME}"
printf "DOCKER_IMAGE_VERSION: %s\n" "${DOCKER_IMAGE_VERSION}"
printf "\n"

# Set COMPONENT_NAME variable if not already set and parameter is present
if [ -z "${COMPONENT_NAME}" ]; then
    if [[ ! -z "${componentName}" ]]; then
        COMPONENT_NAME=${componentName}
    fi
fi

# Set DOCKER_IMAGE_NAME variable if not already set and parameter is present
if [ -z "${DOCKER_IMAGE_NAME}" ]; then
    if [ -z "${dockerImageName}" ]; then
        DOCKER_IMAGE_NAME=${dockerImageName}
    fi
fi

# Get explicit tag for docker image from images built locally if not already set
if [ -z "${DOCKER_IMAGE_VERSION}" ]; then
    if [ -z "${dockerImageVersion}" ]; then
        DOCKER_IMAGE_VERSION=$(docker images liferay/${DOCKER_IMAGE_NAME} --format "{{.Tag}}" | grep ".*T.*Z")
    else
        DOCKER_IMAGE_VERSION=${dockerImageVersion}
    fi
fi

printf "Values used: \n"
printf "COMPONENT_NAME: %s\n" "${COMPONENT_NAME}"
printf "DOCKER_IMAGE_NAME: %s\n" "${DOCKER_IMAGE_NAME}"
printf "DOCKER_IMAGE_VERSION: %s\n" "${DOCKER_IMAGE_VERSION}"
printf "\n"

# Echo commands with expanded variables
set -x

# Clone deployment repository
cd ${TRAVIS_BUILD_DIR}/..

git clone --depth=50 --branch=${DEPLOYMENT_REPO_BRANCH} git@github.com:${DEPLOYMENT_REPO_ORG}/${DEPLOYMENT_REPO_NAME}.git

DEPLOYMENT_REPO_DIR=${TRAVIS_BUILD_DIR}/../${DEPLOYMENT_REPO_NAME}

cd ${DEPLOYMENT_REPO_DIR}

# Update docker image version. Commit and push change.

jq '.containerDefinitions[0].image = "liferay/'${DOCKER_IMAGE_NAME}':'${DOCKER_IMAGE_VERSION}'"' ${DEPLOYMENT_REPO_DIR}/Dockerrun.aws.json|sponge ${DEPLOYMENT_REPO_DIR}/Dockerrun.aws.json

git add ${DEPLOYMENT_REPO_DIR}/Dockerrun.aws.json

git commit -m "${DEPLOYMENT_JIRA_ISSUE} DOCKER_IMAGE_VERSION: ${DOCKER_IMAGE_VERSION}. Trigger TRAVIS_COMMIT: ${TRAVIS_COMMIT}. TRAVIS_BUILD_ID=${TRAVIS_BUILD_ID}"

git push