#!/bin/bash

VERSION_FILE="version.txt"
REFERENCE_BRANCH="origin/master"

exitWithErrorIfNonZero() {
  local STATUS=$1
  local MESSAGE=$2
  [[ ${STATUS} -eq 0 ]] || exitWithError "${MESSAGE}"
}

exitWithError() {
  local MESSAGE=$1
  { echo >&2 "${MESSAGE}"; exit 1; }
}

assertBaseVersionIsValid() {
  local BASE_VERSION=$1  
  if ! [[ $BASE_VERSION =~ ^[0-9]+\.[0-9]+$ ]]; then exitWithError "The base version is invalid. It doesn't not match <number>.<number>"; fi
  if [[ $BASE_VERSION =~ ^0\.0$ ]]; then exitWithError "The version can not be 0.0"; fi
  if [[ $BASE_VERSION =~ ^0[0-9]+\. ]]; then exitWithError "The major version can not be prefixed with 0"; fi
  if [[ $BASE_VERSION =~ \.0[0-9]+ ]]; then exitWithError "The minor version can not be prefixed with 0"; fi
}

readBaseVersion() {
  local VERSION=$(head -n 1 ${VERSION_FILE})
  if [[ "${#VERSION}" -lt 2 ]]; then exitWithError "Could not read base version from ${VERSION_FILE}"; fi
  VERSION=`echo ${VERSION} | sed 's/\\r//g'`  
  assertBaseVersionIsValid $VERSION
  echo "${VERSION}"
}

getCheckoutedOutLatestCommitSha() {
  local GIT_SHA=$(git log -n1 --format=format:"%H")
  if [[ "${#GIT_SHA}" -lt 8 ]]; then exitWithError "Could not get the latest Git Sha. Ensure you are running the script in a git repo"; fi
  echo ${GIT_SHA}
}

isCommitInReferenceBranch() {
  local GIT_SHA=$1	
  local TEMP=$(git log ${REFERENCE_BRANCH} | grep ${GIT_SHA} | wc -l)
  if ! [[ "${?}" = 0 ]]; then exitWithError "Unable to perform get log"; fi
  if [[ "${TEMP}" = 1 ]]; then echo "YES"; else echo "NO"; fi
}

getGitShaForLatestVersionChange() {
  local GIT_SHA=$(git log  -n 1 --format=format:%H ${VERSION_FILE})
  if [[ "${#GIT_SHA}" -lt 8 ]]
  then
    echo "Could not get Git Sha. Ensure you are running the script in a git repo with "${VERSION_FILE}" file" >&2
	return 1
  fi
  echo ${GIT_SHA}
}

getNumberOfCommitsSinceVersionChange() {
  local VERSION_CHANGE_COMMIT_SHA=$(getGitShaForLatestVersionChange)
  if [[ "${?}" = 0 ]]
  then
	return 1
  fi
  NUMBER_OF_COMMITS=$(git rev-list ${VERSION_CHANGE_COMMIT_SHA}..HEAD --count)
  
  
}

getVersion() {
  local BASE_VERSION=$(readBaseVersion)
  echo "CHECK ${?}"
  if ! [[ "${?}" == 0 ]]
  then
	echo "Could not read base version from ${VERSION_FILE}" >&2
	return 1
  fi
  
  if ! [[ $(validateBaseVersion $BASE_VERSION) ]]
  then
	echo "In Valid Base Version" >&2
	return 1
  fi
  
  local GIT_SHORT_SHA=$(git rev-parse --short=7 $(git log -n1 --format=format:%H))
  if [[ "${#GIT_SHORT_SHA}" -lt 8 ]]
  then
    echo "Could not get Git Sha" >&2
	return 1
  fi
  
  
  if [[ $(isCommitInReferenceBranch $GIT_SHA) ]]
  then
    local BUILD_NUMBER=$(git rev-list $(getGitShaForLatestVersionChange)..HEAD --count)
	if ! [[ "${?}" == 0 ]]
	then
	  echo "Could not read build number" >&2
	  return 1;
	fi
	
	local VERSION="${BASE_VERSION}.${BUILD_NUMBER}"
    if [ "${BUILD_NUMBER}" != 0 ]
    then
      VERSION="${VERSION}-${GIT_SHORT_SHA}"
    fi
	
  else  
    local DATE_VERSION=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%Y-%m-%d-%H-%M-%S)
	if ! [[ "${?}" == 0 ]]
	then
	  echo "Could not read date version" >&2
	  return 1
	fi
	
    local VERSION="${BASE_VERSION}-${DATE_VERSION}-${GIT_SHORT_SHA}"
  fi
  echo $VERSION
}

echo "$(getCheckoutedOutLatestCommitSha)"
echo "$(isCommitInReferenceBranch $(getCheckoutedOutLatestCommitSha))"
echo "return value ${?}"  


