#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:" opt; do
  case ${opt} in
    n) NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

aws codepipeline delete-pipeline --name ${NAME}-deployment-pipeline