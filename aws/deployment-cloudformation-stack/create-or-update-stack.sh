#!/usr/bin/env bash

usage() { echo "Usage: $0 [-c config]" 1>&2; exit 1; }

while getopts "c:" OPT; do
  case ${OPT} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    \?) echo "Invalid option -${OPTARG}" >&2
    exit 1
    ;;
  esac
done

[ $# -eq 0 ] && usage

if [ -z "$CONFIG_DIR" ]; then
    usage
fi

stack_type=`basename $CONFIG_DIR`

echo "Trying to create a $stack_type stack"

for param in $CONFIG_DIR/params/*.json; do
  env_name=`basename $param .json`

  stack_name=stack-$stack_type-$env_name

  command="update-stack"

  aws cloudformation describe-stacks --stack-name $stack_name

  set -e

  if [ $? -eq 0 ]; then
     echo "Recreating stack $stack_name"
  else
    echo "First time that the stack $stack_name try to be created"
    command="create-stack"
  fi

  cloudformation_command="aws cloudformation $command  --stack-name $stack_name --template-body file://${CONFIG_DIR}/template/template.json --parameters file://${param}"

  echo ""
  echo "Executing: $cloudformation_command"
  echo ""

  set -euo pipefail

 `$cloudformation_command`

  echo ""
  echo "Stack succesfully created $stack_name"
  echo ""

done