#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while getopts "c:" opt; do
  case ${opt} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

set -o allexport
source ${CONFIG_DIR}/setup_deployment_pipeline.env
set +o allexport

set -x

PATH_TO_PIPELINE_JSON_FILE="${CONFIG_DIR}/codepipeline/deployment-pipeline.json"

# Configure roleArn

jq '.pipeline.roleArn = "arn:aws:iam::'${AWS_ACCOUNT_ID}':role/AWS-CodePipeline-Service"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

# Configure get-deployment-source

jq '.pipeline.stages[0].actions[0].configuration.Owner = "'${DEPLOYMENT_ARTIFACTS_ORG}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[0].actions[0].configuration.Repo = "'${DEPLOYMENT_ARTIFACTS_REPO}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[0].actions[0].configuration.Branch = "'${DEPLOYMENT_ARTIFACTS_BRANCH}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[0].actions[0].configuration.OAuthToken = "'${GITHUB_TOKEN}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

# Configure get-test-source

jq '.pipeline.stages[0].actions[1].configuration.Owner = "'${TEST_ORG}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[0].actions[1].configuration.Repo = "'${TEST_REPO}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[0].actions[1].configuration.Branch = "'${TEST_BRANCH}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[0].actions[1].configuration.OAuthToken = "'${GITHUB_TOKEN}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}


# Configure deploy-to-dev

jq '.pipeline.stages[1].actions[0].configuration.ApplicationName = "'${APPLICATION_NAME}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[1].actions[0].configuration.EnvironmentName = "'${APPLICATION_NAME}'-dev"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}


# Configure test-dev

jq '.pipeline.stages[2].actions[0].configuration.ProjectName = "'${APPLICATION_NAME}'-test-dev"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}


# Configure deploy-to-pre

jq '.pipeline.stages[3].actions[0].configuration.ApplicationName = "'${APPLICATION_NAME}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

jq '.pipeline.stages[3].actions[0].configuration.EnvironmentName = "'${APPLICATION_NAME}'-pre"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}


# Configure test-pre

jq '.pipeline.stages[4].actions[0].configuration.ProjectName = "'${APPLICATION_NAME}'-test-pre"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

# Configure artifactStore

jq '.pipeline.artifactStore.location = "codepipeline-'${APPLICATION_NAME}'"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

# Configure name

jq '.pipeline.name = "'${APPLICATION_NAME}'-deployment-pipeline"' ${PATH_TO_PIPELINE_JSON_FILE}|sponge ${PATH_TO_PIPELINE_JSON_FILE}

