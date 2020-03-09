#!/bin/bash

baseVersion=$(head -n 1 version.txt)
baseVersion=`echo $baseVersion | sed 's/\\r//g'`
gitSha=$(git rev-parse --short=7 $(git log -n1 --format=format:%H))
[[ $baseVersion =~ ^[0-9]+\.[0-9]+$ ]] || (echo "The pattern <number(s)>.<number(s)> is not met" && exit 1)
[[ $baseVersion =~ ^0\.0$ ]] && (echo "The version can not be 0.0" && exit 1)
[[ $baseVersion =~ ^0[0-9]+\. ]] && (echo "The major version can not be prefixed with 0" && exit 1)
[[ $baseVersion =~ \.0[0-9]+ ]] && (echo "The minor version can not be prefixed with 0" && exit 1)

isMasterCommit=$(git log origin/master | grep $(git log -n1 --format=format:"%H"))

if  [[ "$isMasterCommit" =~ [A-Za-z0-9] ]] ;
then
  buildVersion=$(git rev-list $(git log  -n 1 --format=format:%H version.txt)..HEAD --count)
  version="$baseVersion.$buildVersion"
  if [ "$buildVersion" != "0" ]
  then
    version="$version-$gitSha"
  fi
else  
  dateversion=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%Y-%m-%d-%H-%M-%S)
  version="$baseVersion-$dateversion-$gitSha"
fi
echo $version

