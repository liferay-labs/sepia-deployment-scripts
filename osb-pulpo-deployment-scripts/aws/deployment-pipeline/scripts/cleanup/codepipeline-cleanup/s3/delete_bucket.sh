#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:" OPT; do
  case ${OPT} in
    n) BUCKET_NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

if (aws s3api head-bucket --bucket ${BUCKET_NAME}); then

  echo "S3 bucket ${BUCKET_NAME} exists"

  echo "Deleting S3 bucket ${BUCKET_NAME}"

  aws s3 rb s3://${BUCKET_NAME} --force

else

  echo "S3 bucket ${BUCKET_NAME} does not exist"

fi



