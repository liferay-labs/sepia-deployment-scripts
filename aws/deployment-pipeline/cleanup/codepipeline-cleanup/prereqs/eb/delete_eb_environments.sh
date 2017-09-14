#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:e:r:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
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
  ${DIR}/delete_eb_environment.sh \
	-n ${APPLICATION_NAME} -e ${ENVIRONMENT_SUFFIX}
done
