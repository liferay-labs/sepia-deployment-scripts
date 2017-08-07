#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

while getopts ":n:e:" opt; do
  case ${opt} in
    n) NAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

./create_eb_environment.sh -n ${NAME} -e dev
./create_eb_environment.sh -n ${NAME} -e pre
./create_eb_environment.sh -n ${NAME} -e prod