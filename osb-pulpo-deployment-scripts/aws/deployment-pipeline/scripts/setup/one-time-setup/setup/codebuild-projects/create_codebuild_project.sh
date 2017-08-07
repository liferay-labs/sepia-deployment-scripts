#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:e:" opt; do
  case ${opt} in
    n) NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

aws codebuild create-project --name ${NAME} \
	--source type="CODEPIPELINE" \
	--artifacts type="CODEPIPELINE" \
	--environment file://${AWS_DIR}/deployment-pipeline/config/prereqs/codebuild-projects/codebuild-project-environment-${ENVIRONMENT}.json \
	--service-role "arn:aws:iam::569796009809:role/CodeBuildServiceRole"
