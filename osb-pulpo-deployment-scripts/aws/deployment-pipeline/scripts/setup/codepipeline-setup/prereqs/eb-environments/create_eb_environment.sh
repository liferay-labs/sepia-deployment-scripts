#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

set -x

while getopts ":n:e:" opt; do
  case ${opt} in
    n) application_name="${OPTARG}"
    ;;
    e) environment_suffix="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done


echo "Cleanup existing deployment artifacts"

DEPLOYMENT_ARTIFACTS_ORG=liferay-labs
DEPLOYMENT_ARTIFACTS_REPO=com-liferay-osb-${application_name}-deployment-private
DEPLOYMENT_ARTIFACTS_BRANCH=7.0.x-private

DEPLOYMENT_ARTIFACTS_URL=https://github.com/${DEPLOYMENT_ARTIFACTS_ORG}/${DEPLOYMENT_ARTIFACTS_REPO}/archive/${DEPLOYMENT_ARTIFACTS_BRANCH}.zip

rm -r ${AWS_DIR}/deployment-pipeline/scripts/setup/codepipeline-setup/prereqs/eb-environments/.elasticbeanstalk/
rm -r ${AWS_DIR}/deployment-pipeline/scripts/setup/codepipeline-setup/prereqs/eb-environments/logstash/
rm -r ${AWS_DIR}/deployment-pipeline/scripts/setup/codepipeline-setup/prereqs/eb-environments/Dockerrun.aws.json
rm -r ${AWS_DIR}/deployment-pipeline/scripts/setup/codepipeline-setup/prereqs/eb-environments/README.md


echo "Download and unzip deployment artifacts"

wget ${DEPLOYMENT_ARTIFACTS_URL} -O deployment-artifacts.zip

unzip -o deployment-artifacts.zip

rm deployment-artifacts.zip

shopt -s dotglob # for considering dot files (turn on dot files)

mv ${DEPLOYMENT_ARTIFACTS_REPO}-${DEPLOYMENT_ARTIFACTS_BRANCH}/* .

rmdir ${DEPLOYMENT_ARTIFACTS_REPO}-${DEPLOYMENT_ARTIFACTS_BRANCH}


echo "Generate environment variables for environment"

EB_ENV_VARS=`cat ${AWS_DIR}/deployment-pipeline/config/prereqs/eb-environments/env-vars/env-vars.cfg`

echo "EB_ENV_VARS: ${EB_ENV_VARS}"

EB_ENV_VARS_EVALUATED=`echo $(eval "echo ${EB_ENV_VARS}")`

echo "EB_ENV_VARS_EVALUATED: ${EB_ENV_VARS_EVALUATED}"


echo "Create eb environment"

eb create \
	--instance_type t2.small \
	--cname ${application_name}-${environment_suffix} \
	--region eu-west-1 ${application_name}-${environment_suffix} \
	--envvars "${EB_ENV_VARS_EVALUATED}"
