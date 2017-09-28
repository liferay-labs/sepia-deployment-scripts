#!/usr/bin/env bash

set -euo pipefail

while getopts ":c:" opt; do
  case ${opt} in
    c) CNAME="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

MAX_TRIES=20
SLEEP_SECONDS=30

TRY_NUMBER=1
echo "Checking up to ${MAX_TRIES} times every ${SLEEP_SECONDS} for ${CNAME} to be available"

while [ `aws elasticbeanstalk check-dns-availability --cname-prefix ${CNAME} | jq -r '.Available'` == "false" ]; do

  echo "Try number $TRY_NUMBER. Cname ${CNAME} is currently not available. Checking again in ${SLEEP_SECONDS} seconds"

  sleep ${SLEEP_SECONDS}
  TRY_NUMBER=$[$TRY_NUMBER+1]

  if [ "$TRY_NUMBER" -gt "$MAX_TRIES" ]
  then
   echo "Maximum number of tries (${MAX_TRIES}) for cname ${CNAME} to be available reached. Aborting"
   exit 1
  fi
done

echo "Cname ${CNAME} is available"