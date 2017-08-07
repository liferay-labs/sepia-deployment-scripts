#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

aws iam create-role --role-name CodeBuildServiceRole --assume-role-policy-document file://create-role.json
