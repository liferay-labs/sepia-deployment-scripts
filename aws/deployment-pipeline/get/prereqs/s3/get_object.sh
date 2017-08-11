#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:k:c:" OPT; do
  case ${OPT} in
    n) BUCKET_NAME="${OPTARG}"
    ;;
    k) KEY="${OPTARG}"
    ;;
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

PATH_TO_FILE=${CONFIG_DIR}/prereqs/s3/docker-credentials/dockercfg

aws s3api get-object --bucket ${BUCKET_NAME} --key ${KEY} ${PATH_TO_FILE}