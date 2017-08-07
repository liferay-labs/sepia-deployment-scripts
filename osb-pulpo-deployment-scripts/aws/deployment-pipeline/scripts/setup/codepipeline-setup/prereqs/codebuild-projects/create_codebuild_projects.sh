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

./create_codebuild_project.sh -n ${NAME}-test-dev  -e dev
./create_codebuild_project.sh -n ${NAME}-test-pre  -e pre
./create_codebuild_project.sh -n ${NAME}-test-prod -e prod