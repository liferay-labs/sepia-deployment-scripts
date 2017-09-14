#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:e:s:c:r:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIX="${OPTARG}"
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

CODEBUILD_PROJECT_NAME=${APPLICATION_NAME}-test-${ENVIRONMENT_SUFFIX}

if (aws codebuild list-projects --region ${REGION} | jq -r '.projects[]' | grep -q "^${CODEBUILD_PROJECT_NAME}$"); then

  echo "CodeBuild project ${CODEBUILD_PROJECT_NAME} already exists"

else

  echo "Creating CodeBuild project ${CODEBUILD_PROJECT_NAME}"

  aws codebuild create-project --name ${CODEBUILD_PROJECT_NAME} \
	--source type="CODEPIPELINE" \
	--artifacts type="CODEPIPELINE" \
	--environment file://${CONFIG_DIR}/prereqs/codebuild/codebuild-project-test-environment-${ENVIRONMENT_SUFFIX}.json \
	--service-role ${SERVICE_ROLE_ARN} \
	--region ${REGION}

fi