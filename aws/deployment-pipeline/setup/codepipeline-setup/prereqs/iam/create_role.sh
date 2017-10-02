#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":r:a:" opt; do
  case ${opt} in
    r) ROLE_NAME="${OPTARG}"
    ;;
    a) ASSUME_ROLE_POLICY_DOCUMENT_PATH="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

if (aws iam get-role --role-name ${ROLE_NAME}); then

  echo "Role ${ROLE_NAME} already exists"

else

  echo "Creating Role ${ROLE_NAME} with assume role policy ${ASSUME_ROLE_POLICY_DOCUMENT_PATH}"

  aws iam create-role \
	--role-name ${ROLE_NAME} \
	--assume-role-policy-document file://${ASSUME_ROLE_POLICY_DOCUMENT_PATH}

fi
