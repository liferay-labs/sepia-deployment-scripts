#!/usr/bin/env bash

set -euo pipefail

while getopts ":r:p:" opt; do
  case ${opt} in
    r) ROLE_NAME="${OPTARG}"
    ;;
    p) POLICY_NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -x

if ( aws iam list-roles |jq -r '.Roles[].RoleName' |grep -q "^${ROLE_NAME}$" ); then

  echo "Role ${ROLE_NAME} exists."

else

  echo "Role ${ROLE_NAME} does not exist. Skipping delete-role-policy."
  exit 0

fi

if ( aws iam list-role-policies --role-name ${ROLE_NAME} |jq -r '.PolicyNames[]' |grep -q "^${POLICY_NAME}$" ); then

  echo "Role policy ${POLICY_NAME} for role ${ROLE_NAME} exists"

  echo "Deleting role policy ${POLICY_NAME} for role ${ROLE_NAME}"

  aws iam delete-role-policy \
	--role-name ${ROLE_NAME} \
	--policy-name ${POLICY_NAME}

else

  echo "Role policy ${POLICY_NAME} for role ${ROLE_NAME} does not exist. Skipping delete-role-policy."

fi