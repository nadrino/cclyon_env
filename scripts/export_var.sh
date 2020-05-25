#!/bin/bash

if [ "" == "$1" ]
then
  echo -e "${ERROR} Usage : . ./export_var.sh NAME VALUE or"
  echo -e "${ERROR} Usage : . ./export_var.sh NAME=VALUE"
  exit 1;
fi

if [ "" == "$2" ]
then
  IFS='=' read -ra args <<<"$1";
  # declare -p args;
  # IFS='=' read -r -a args <<< "$1"
  export VAR_NAME=${args[0]}
  export VAR_VALUE=${args[1]}
else
  export VAR_NAME=$1
  export VAR_VALUE=$2
fi

export ${VAR_NAME}=${VAR_VALUE}
# echo ${VAR_NAME}=${VAR_VALUE}
# shift
# shift
