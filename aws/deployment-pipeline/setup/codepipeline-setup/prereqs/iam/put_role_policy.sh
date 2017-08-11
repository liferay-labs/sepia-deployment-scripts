#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts ":r:p:d:" opt; do
  case ${opt} in
    r) ROLE_NAME="${OPTARG}"
    ;;
    p) POLICY_NAME="${OPTARG}"
    ;;
    d) PATH_TO_POLICY_DOCUMENT="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

aws iam put-role-policy \
	--role-name ${ROLE_NAME} \
	--policy-name ${POLICY_NAME} \
	--policy-document file://${PATH_TO_POLICY_DOCUMENT}
