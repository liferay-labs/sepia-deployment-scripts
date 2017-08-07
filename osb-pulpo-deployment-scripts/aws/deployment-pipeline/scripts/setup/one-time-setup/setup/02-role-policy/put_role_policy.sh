#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

aws iam put-role-policy \
	--role-name CodeBuildServiceRole \
	--policy-name CodeBuildServiceRolePolicy \
	--policy-document file://put-role-policy.json
