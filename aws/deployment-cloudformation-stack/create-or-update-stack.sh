#!/usr/bin/env bash

function usage {
    echo "usage: $0 [-c configdir] [-r region]"
    echo "  -c configdir     specify the the config file that created the stack"
    echo "  -r awsregion     (optional) AWS_REGION of the stack, if this param is empty, the env variable AWS_REGION will be used instead"
    exit 1
}

while getopts "c:r:" OPT; do
  case ${OPT} in
    c) CONFIG_DIR="${OPTARG}"
    ;;
    r) REGION="${OPTARG}"
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

if [ -z "$REGION" ]; then
    export REGION=$AWS_REGION
fi

stack_type=`basename $CONFIG_DIR`

echo "Trying to create a $stack_type stack"

for param in $CONFIG_DIR/params/*.json; do
  env_name=`basename $param .json`

  stack_name=stack-$stack_type-$env_name

  command="update-stack"

  cloudformation_command="aws cloudformation describe-stacks --stack-name $stack_name --region $REGION"

  echo ""
  echo "Executing: $cloudformation_command"
  echo ""

 ${cloudformation_command}

  if [ $? -eq 0 ]; then
     echo "Recreating stack $stack_name"
  else
    echo "First time that the stack $stack_name try to be created"
    command="create-stack"
  fi

  cloudformation_command="aws cloudformation $command  --stack-name $stack_name --template-body file://${CONFIG_DIR}/template/template.json --parameters file://${param} --region $REGION"

  echo ""
  echo "Executing: $cloudformation_command"
  echo ""

 `$cloudformation_command`

 if [ $? -eq 0 ]; then
     echo ""
     echo "Stack succesfully created/updated $stack_name"
     echo ""
  else
     echo ""
     echo "The stack $stack_name won't be created/updated"
     echo ""
  fi

done