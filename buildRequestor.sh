#!/bin/bash

OWNER_NAME="ZeroWasteTeam"
REPOSITORY_NAME="SampleJavaMavenPackage"
BUILD_BRANCH="master"
BUILD_SHA=$(git log origin/master -n 1 --format=format:"%H")

while getopts o:r:s:b: OPTION
do
  case ${OPTION} in
  o)
    OWNER_NAME="${OPTARG}"
	;;
  r)
    REPOSITORY_NAME="${OPTARG}"
	;;
  s)
    BUILD_SHA="${OPTARG}"
	;;
  b)
    BUILD_BRANCH="${OPTARG}"
	;;
  ?)
    echo "${0} [-b <branchname>] [-s <git sha >] [-r <repositoryname>] [-o <ownername>] "
	exit 1;
    ;;
  esac
done

TOKEN=$(head -n 1 token.txt)
TOKEN=`echo ${TOKEN} | sed 's/\\r//g'`

case "${BUILD_BRANCH}" in
	master)
		BUILD_TYPE=rebuild
		;;
	release-*)
		BUILD_TYPE=release
		;;
    *)
		BUILD_TYPE=test
		;;
esac



echo "Build type is ${BUILD_TYPE}"
echo "*****************************"
echo "Owner name is ${OWNER_NAME}"
echo "Repository name is ${REPOSITORY_NAME}"
echo "Build branch is ${BUILD_BRANCH}"
echo "Build sha is ${BUILD_SHA}"

COMMAND="curl -H \"Accept: application/vnd.github.everest-preview+json\" -H \"Authorization: token ${TOKEN}\" --request POST --data '{\"event_type\": \"${BUILD_TYPE}\", \"client_payload\":{ \"buildBranch\" : \"${BUILD_BRANCH}\", \"buildSha\":\"${BUILD_SHA}\" }}' https://api.github.com/repos/${OWNER_NAME}/${REPOSITORY_NAME}/dispatches"


eval "$COMMAND"



