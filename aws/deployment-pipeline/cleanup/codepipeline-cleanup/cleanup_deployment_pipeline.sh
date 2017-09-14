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

codepipeline/delete_deployment_pipeline.sh \
	-n ${APPLICATION_NAME} \
	-r ${REGION}

prereqs/codebuild/delete_codebuild_projects.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIXES} \
	-r ${REGION}

prereqs/eb/delete_eb_environments.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIXES}

prereqs/iam/delete_role_policy.sh \
	-r ${CODEBUILD_SERVICE_ROLE_NAME} \
	-p ${CODEBUILD_SERVICE_ROLE_POLICY} \

prereqs/iam/delete_role.sh \
	-n ${APPLICATION_NAME}

prereqs/s3/delete_bucket.sh \
	-n ${BUCKET_NAME}
