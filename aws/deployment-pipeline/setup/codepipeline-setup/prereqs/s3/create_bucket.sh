#!/usr/bin/env bash

set -euo pipefail

while getopts ":n:r:" OPT; do
  case ${OPT} in
    n) BUCKET_NAME="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

if (aws s3api head-bucket --bucket ${BUCKET_NAME}); then

  echo "S3 bucket ${BUCKET_NAME} already exists"

else

  echo "Creating S3 bucket ${BUCKET_NAME}"

  aws s3 mb s3://${BUCKET_NAME} --region ${REGION}

fi



