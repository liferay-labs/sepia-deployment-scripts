#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:e:r:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    e) ENVIRONMENT_SUFFIX="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

ENVIRONMENT_NAME=${APPLICATION_NAME}-${ENVIRONMENT_SUFFIX}

if (aws elasticbeanstalk describe-environments --application-name ${APPLICATION_NAME} --environment-names ${ENVIRONMENT_NAME} --region ${REGION}| jq '(.Environments[] | select(.Status != "Terminated"))' | grep -q ${ENVIRONMENT_NAME}); then

  echo "EB environment ${ENVIRONMENT_NAME} for application ${APPLICATION_NAME} exists"

  echo "Deleting EB environment ${ENVIRONMENT_NAME}"

  aws elasticbeanstalk terminate-environment \
	--environment-name ${ENVIRONMENT_NAME} \
	--region ${REGION}

else

  echo "EB environment ${ENVIRONMENT_NAME} for application ${APPLICATION_NAME} does not exist. Skipping terminate."

fi