#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":n:c:" opt; do
  case ${opt} in
    n) APPLICATION_NAME="${OPTARG}"
    ;;
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

ROLE_NAME="CodeBuildServiceRole-${APPLICATION_NAME}"

if (aws iam get-role --role-name ${ROLE_NAME}); then

  echo "Role ${ROLE_NAME} already exists"

else

  echo "Creating Role ${ROLE_NAME}"
  aws iam create-role --role-name ${ROLE_NAME} --assume-role-policy-document file://${CONFIG_DIR}/prereqs/iam/role.json

fi

