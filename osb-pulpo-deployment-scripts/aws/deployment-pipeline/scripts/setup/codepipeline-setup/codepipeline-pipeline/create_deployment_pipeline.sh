#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

aws codepipeline create-pipeline --cli-input-json file://${AWS_DIR}/deployment-pipeline/config/codepipeline-pipeline/deployment-pipeline.json

