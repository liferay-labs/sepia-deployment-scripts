#!/usr/bin/env bash

set -euo pipefail

while getopts ":o:u:p:i:r:" opt; do
  case ${opt} in
    o) DOCKER_ORG="${OPTARG}"
    ;;
    u) DOCKER_USER="${OPTARG}"
    ;;
    p) DOCKER_PWD="${OPTARG}"
    ;;
    i) DOCKER_IMAGE_NAME="${OPTARG}"
    ;;
    r) DOCKER_IS_PRIVATE="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

# Get authentication token

TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${DOCKER_USER}'", "password": "'${DOCKER_PWD}'"}' https://hub.docker.com/v2/users/login/ |jq -r .token)


# Create repository if it doesn't exist yet

if (curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${DOCKER_ORG}/?page_size=100 |jq -r '.results|.[]|.name' |grep -q "^${DOCKER_IMAGE_NAME}$"); then

  echo "Docker hub repository ${DOCKER_IMAGE_NAME} already exists in org ${DOCKER_ORG}"

  exit 0

else

  echo "Creating Docker hub repository ${DOCKER_IMAGE_NAME} in org ${DOCKER_ORG}"

  BODY=$(cat  << EOF
{
	"namespace": "${DOCKER_ORG}",
	"name": "${DOCKER_IMAGE_NAME}",
	"description": "",
    "full_description":  "",
	"is_private": "${DOCKER_IS_PRIVATE}"
}
EOF
)

  curl -s \
  	-H "Authorization: JWT ${TOKEN}" \
  	-H "Content-Type: application/json" \
  	-X POST \
  	-d "${BODY}" \
  	https://hub.docker.com/v2/repositories/

fi

# Check if repository was created successfully

if (curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${DOCKER_ORG}/?page_size=100 |jq -r '.results|.[]|.name' |grep -q "^${DOCKER_IMAGE_NAME}$"); then

  echo "Docker hub repository ${DOCKER_IMAGE_NAME} was created in org ${DOCKER_ORG}"

  exit 0

else

  echo "Could not create Docker hub repository ${DOCKER_IMAGE_NAME} in org ${DOCKER_ORG}"

  exit 1

fi