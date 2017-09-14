#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:r:" opt; do
  case ${opt} in
    n) name="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

aws codebuild delete-project \
	--name ${name} \
	--region ${REGION}
