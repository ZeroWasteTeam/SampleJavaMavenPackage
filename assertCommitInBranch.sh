#!/bin/bash

COMMIT=$1
BRANCH=$2

TEMP=$(git log ${BRANCH} --format=format:%H | grep ${COMMIT} | wc -l)

if [[ "${?}" != 0 ]] ; 
then 
  echo >&2 "Unable to perform operation. Ensure it's a git repo and installation of git"
  exit 1;
fi

if [[ "${TEMP}" = 0 ]] ;
then
  echo >&2 "commit not in branch"
  exit 1;
fi

