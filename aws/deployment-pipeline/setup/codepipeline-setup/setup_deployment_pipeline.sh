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

prereqs/dockerhub/create_dockerhub_repository.sh \
	-o ${DOCKER_ORG} \
	-u ${DOCKER_USER} \
	-p ${DOCKER_PWD} \
	-i ${DOCKER_IMAGE_NAME} \
	-r ${DOCKER_IS_PRIVATE}

prereqs/s3/create_bucket.sh \
	-n ${BUCKET_NAME} \
	-r ${REGION}

prereqs/s3/put_object.sh \
	-n ${BUCKET_NAME} \
	-k ${DOCKER_CREDENTIALS_KEY} \
	-c ${CONFIG_DIR}

CODEBUILD_ASSUME_ROLE_POLICY_DOCUMENT_PATH=${CONFIG_DIR}/prereqs/iam/role.json

prereqs/iam/create_role.sh \
	-r ${CODEBUILD_SERVICE_ROLE_NAME} \
	-a ${CODEBUILD_ASSUME_ROLE_POLICY_DOCUMENT_PATH}

PATH_TO_CODEBUILD_POLICY_DOCUMENT=${CONFIG_DIR}/prereqs/iam/codebuild-role-policy.json

prereqs/iam/put_role_policy.sh \
	-r ${CODEBUILD_SERVICE_ROLE_NAME} \
	-p ${CODEBUILD_SERVICE_ROLE_POLICY} \
	-d ${PATH_TO_CODEBUILD_POLICY_DOCUMENT}

PATH_TO_EB2_EC2_POLICY_DOCUMENT=${CONFIG_DIR}/prereqs/iam/eb-ec2-role-policy.json

prereqs/iam/put_role_policy.sh \
	-r ${EB_EC2_SERVICE_ROLE_NAME} \
	-p ${EB_EC2_SERVICE_ROLE_POLICY} \
	-d ${PATH_TO_EB2_EC2_POLICY_DOCUMENT}

CODEPIPELINE_ASSUME_ROLE_POLICY_DOCUMENT_PATH=${CONFIG_DIR}/prereqs/iam/codepipeline-role.json

prereqs/iam/create_role.sh \
	-r ${CODEPIPELINE_SERVICE_ROLE_NAME} \
	-a ${CODEPIPELINE_ASSUME_ROLE_POLICY_DOCUMENT_PATH}

PATH_TO_CODEPIPELINE_POLICY_DOCUMENT=${CONFIG_DIR}/prereqs/iam/codepipeline-role-policy.json

prereqs/iam/put_role_policy.sh \
	-r ${CODEPIPELINE_SERVICE_ROLE_NAME} \
	-p ${CODEPIPELINE_SERVICE_ROLE_POLICY} \
	-d ${PATH_TO_CODEPIPELINE_POLICY_DOCUMENT}

PATH_TO_DEPLOYMENT_ARTIFACTS_REPO=${TRAVIS_BUILD_DIR}/../${DEPLOYMENT_ARTIFACTS_REPO}

prereqs/eb/create_eb_environments.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIXES} \
	-d ${PATH_TO_DEPLOYMENT_ARTIFACTS_REPO} \
	-i ${INSTANCE_TYPE} \
	-g ${REGION} \
	-c ${CONFIG_DIR}

prereqs/codebuild/create_codebuild_projects.sh \
	-n ${APPLICATION_NAME} \
	-e ${ENVIRONMENT_SUFFIXES} \
	-s ${CODEBUILD_SERVICE_ROLE_ARN} \
	-c ${CONFIG_DIR} \
	-r ${REGION}

codepipeline/create_deployment_pipeline.sh \
	-c ${CONFIG_DIR} \
	-r ${REGION}

echo "Setup Deployment Pipeline Completed!"