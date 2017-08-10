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

set -x

prereqs/s3/create_bucket.sh \
	-n ${BUCKET_NAME}

prereqs/s3/put_object.sh \
	-n ${BUCKET_NAME} \
	-k ${DOCKER_CREDENTIALS_KEY} \
	-c ${CONFIG_DIR}

prereqs/iam/create_role.sh \
	-n ${APPLICATION_NAME}

prereqs/iam/put_role_policy.sh \
	-n ${APPLICATION_NAME} \
	-c ${CONFIG_DIR}

prereqs/eb/create_eb_environments.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIXES} \
	-o ${DEPLOYMENT_ARTIFACTS_ORG} \
	-r ${DEPLOYMENT_ARTIFACTS_REPO} \
	-b ${DEPLOYMENT_ARTIFACTS_BRANCH} \
	-i ${INSTANCE_TYPE} \
	-g ${REGION} \
	-c ${CONFIG_DIR}

prereqs/codebuild/create_codebuild_projects.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIXES} \
	-s ${SERVICE_ROLE_ARN} \
	-c ${CONFIG_DIR}

codepipeline/create_deployment_pipeline.sh \
	-c ${CONFIG_DIR}
