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

aws iam put-role-policy \
	--role-name CodeBuildServiceRole-${APPLICATION_NAME} \
	--policy-name CodeBuildServiceRolePolicy-${APPLICATION_NAME} \
	--policy-document file://${CONFIG_DIR}/prereqs/iam/role-policy.json
