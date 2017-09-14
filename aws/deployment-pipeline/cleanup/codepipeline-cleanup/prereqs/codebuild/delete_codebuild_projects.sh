#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:e:r:" opt; do
  case ${opt} in
    n) NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIXES="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -x

IFS=$','

for ENVIRONMENT_SUFFIX in ${ENVIRONMENT_SUFFIXES}; do
  ${DIR}/delete_codebuild_project.sh \
	-n ${NAME}-test-${ENVIRONMENT_SUFFIX} \
	-r ${REGION}
done
