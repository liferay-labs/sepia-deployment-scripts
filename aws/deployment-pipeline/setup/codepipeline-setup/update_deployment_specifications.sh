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

prereqs/s3/update_docker_config_auth_token.sh \
	-c ${CONFIG_DIR}

prereqs/codebuild/update_codebuild_project_specifications.sh \
	-c ${CONFIG_DIR}

codepipeline/update_deployment_pipeline_specification.sh \
	-c ${CONFIG_DIR}
