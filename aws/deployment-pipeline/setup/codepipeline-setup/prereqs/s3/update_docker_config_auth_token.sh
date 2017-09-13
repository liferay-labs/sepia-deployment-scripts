#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts "c:" opt; do
  case ${opt} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -o allexport
source ${CONFIG_DIR}/setup_deployment_pipeline.env
set +o allexport

set -x

PATH_TO_DOCKER_CREDENTIAL_CONFIG_FILE="${CONFIG_DIR}/prereqs/s3/docker-credentials/dockercfg"

PATH_TO_DOCKER_CREDENTIAL_CONFIG_FILE_IN_HOME="${HOME}/.docker/config.json"

if [ -z "$DOCKER_AUTH_TOKEN" ];
then
	echo "DOCKER_AUTH_TOKEN is unset. Trying to read it from ${PATH_TO_DOCKER_CREDENTIAL_CONFIG_FILE_IN_HOME}";

	DOCKER_AUTH_TOKEN=`cat ${PATH_TO_DOCKER_CREDENTIAL_CONFIG_FILE_IN_HOME} |jq -r '.auths["https://index.docker.io/v1/"].auth'`;
else
	echo "DOCKER_AUTH_TOKEN is already set";
fi

if [[ "$DOCKER_AUTH_TOKEN" == 'null' ]];
then
	echo "DOCKER_AUTH_TOKEN could not be set. Make sure you have logged into Docker and the config.json files has the correct format";

	exit 1;
fi

jq '.["https://index.docker.io/v1/"].auth = "'${DOCKER_AUTH_TOKEN}'"' ${PATH_TO_DOCKER_CREDENTIAL_CONFIG_FILE}|sponge ${PATH_TO_DOCKER_CREDENTIAL_CONFIG_FILE}