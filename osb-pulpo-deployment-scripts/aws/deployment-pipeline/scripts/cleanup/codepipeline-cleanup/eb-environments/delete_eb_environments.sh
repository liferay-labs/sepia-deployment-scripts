#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

./delete_eb_environment.sh -n pulpo-engine-assets -e dev
./delete_eb_environment.sh -n pulpo-engine-assets -e pre
./delete_eb_environment.sh -n pulpo-engine-assets -e prod