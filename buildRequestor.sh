#!/bin/bash

OWNER_NAME="ZeroWasteTeam"
REPOSITORY_NAME="SampleJavaMavenPackage"
BUILD_TYPE="rebuild" # test, release
BUILD_BRANCH="master"
BUILD_SHA=$(git log origin/master -n 1 --format=format:"%H")

while getopts o:r:t:s: OPTION
do
  case ${OPTION} in
  o)
    OWNER_NAME="${OPTARG}"
	;;
  r)
    REPOSITORY_NAME="${OPTARG}"
	;;
  t)
    BUILD_TYPE="${OPTARG}"
	;;
  s)
    BUILD_SHA="${OPTARG}"
	;;
  b)
    BUILD_BRANCH="${OPTARG}"
	;;
  ?)
    echo "USAGE is wrong" #The usage has to be done
    ;;
  esac
done

TOKEN=$(head -n 1 token.txt)
TOKEN=`echo ${TOKEN} | sed 's/\\r//g'`

if [[ "${BUILD_TYPE}" = "rebuild" ]] ;
then
  if ! [[ "${BUILD_BRANCH}" = "master" ]] ;
  then
    BUILD_BRANCH="master"
	echo "Build branch has to be master when build type is rebuild"
  fi
fi

COMMAND=curl -H "Accept: application/vnd.github.everest-preview+json" -H "Authorization: token {}" --request POST --data '{"event_type": "${BUILD_TYPE}", "client_payload":{ "buildType" : "${BUILD_TYPE}", "buildBranch" : "${BUILD_BRANCH}", "buildSha":"${BUILD_SHA}" }}' https://api.github.com/repos/${OWNER_NAME}/${REPOSITORY_NAME}/dispatches

$(${COMMAND})



