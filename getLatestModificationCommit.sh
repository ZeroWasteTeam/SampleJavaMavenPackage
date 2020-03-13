#!/bin/bash
PATH=${1}
RESULT="$(git log  -n 1 --format=format:%H ${PATH})"
if [[ "${?}" != 0 ]] ; 
then 
  echo >&2 "Unable to perform operation. Ensure it's a git repo and installation of git"
  exit 1;
fi
echo ${RESULT}

