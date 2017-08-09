#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

aws codepipeline get-pipeline \
	--name ${APPLICATION_NAME}-deployment-pipeline