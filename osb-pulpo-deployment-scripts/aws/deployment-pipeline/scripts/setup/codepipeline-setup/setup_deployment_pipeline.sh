#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:e:" opt; do
  case ${opt} in
    n) NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

prereqs/eb-environments/create_eb_environments.sh
prereqs/codebuild-projects/create_codebuild_projects.sh
codepipeline-pipeline/create_deployment_pipeline.sh ${NAME}
