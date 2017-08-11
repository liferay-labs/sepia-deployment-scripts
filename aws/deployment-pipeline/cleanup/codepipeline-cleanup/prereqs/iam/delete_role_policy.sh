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

aws iam delete-role-policy \
	--role-name ${ROLE_NAME} \
	--policy-name ${POLICY_NAME}
