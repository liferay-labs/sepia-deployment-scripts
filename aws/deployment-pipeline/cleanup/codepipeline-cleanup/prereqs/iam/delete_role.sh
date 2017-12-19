#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

ROLE_NAME="CodeBuildServiceRole-${APPLICATION_NAME}"

if ( aws iam list-roles |jq -r '.Roles[].RoleName' |grep -q "^${ROLE_NAME}$" ); then

  echo "Role ${ROLE_NAME} exists."

  echo "Deleting role ${ROLE_NAME}."

  aws iam delete-role --role-name ${ROLE_NAME}

else

  echo "Role ${ROLE_NAME} does not exist. Skipping delete-role."

fi
