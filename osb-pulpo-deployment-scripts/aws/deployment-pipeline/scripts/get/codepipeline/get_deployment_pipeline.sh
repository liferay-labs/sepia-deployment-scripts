#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:" opt; do
  case ${opt} in
    n) application_name="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

aws codepipeline get-pipeline --name ${application_name}-deployment-pipeline