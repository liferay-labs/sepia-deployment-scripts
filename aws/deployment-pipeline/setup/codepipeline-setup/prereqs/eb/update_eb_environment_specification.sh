#!/usr/bin/env bash

set -euo pipefail

while getopts "c:p:" OPT; do
  case ${OPT} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    p) PATH_TO_EB_DOCKER_JSON_FILE="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

echo "CONFIG_DIR: ${CONFIG_DIR}"

set -o allexport
source ${CONFIG_DIR}/setup_deployment_pipeline.env
set +o allexport

set -x

# Configure authentication bucket name

jq '.authentication.bucket = "'${BUCKET_NAME}'"' ${PATH_TO_EB_DOCKER_JSON_FILE}|sponge ${PATH_TO_EB_DOCKER_JSON_FILE}

# Configure docker image

jq '.containerDefinitions[0].image = "'${DOCKER_ORG}'/'${DOCKER_IMAGE_NAME}':'${DOCKER_IMAGE_VERSION}'"' ${PATH_TO_EB_DOCKER_JSON_FILE}|sponge ${PATH_TO_EB_DOCKER_JSON_FILE}

# Configure container image

jq '.containerDefinitions[0].name = "'${APPLICATION_NAME}'"' ${PATH_TO_EB_DOCKER_JSON_FILE}|sponge ${PATH_TO_EB_DOCKER_JSON_FILE}


# Configure global application name

cat ${PATH_TO_EB_DOCKER_JSON_FILE}/../.elasticbeanstalk/config.yml | docker run -i --rm jlordiales/jyparser set ".global.application_name" \"${APPLICATION_NAME}\"
