#!/bin/bash


ref1=$1
ref2=$2

echo "Checking Version File is Modified"
numberOfFilesModified=$(git diff --name-only "$ref1..$ref2" | wc -l)
isVersionFileModified=$(git diff --name-only "$ref1..$ref2" version.txt | wc -l)

baseVersion=$(git show $ref2:version.txt)
baseVersion=`echo $baseVersion | sed 's/\\r//g'`

echo "base version $baseVersion"

gitSha=$(git rev-parse --short=7 $(git log -n1 --format=format:%H))
[[ $baseVersion =~ ^[0-9]+\.[0-9]+$ ]] || (echo "The pattern <number(s)>.<number(s)> is not met" && exit 1)
[[ $baseVersion =~ ^0\.0$ ]] && (echo "The version can not be 0.0" && exit 1)
[[ $baseVersion =~ ^0[0-9]+\. ]] && (echo "The major version can not be prefixed with 0" && exit 1)
[[ $baseVersion =~ \.0[0-9]+ ]] && (echo "The minor version can not be prefixed with 0" && exit 1)


initialVersion=$(git show $ref1:version.txt)
finalVersion=$(git show $ref2:version.txt)

if [ $isVersionFileModified  -eq 1 ]
then
  if [ $numberOfFilesModified -gt 1 ]
  then
	  echo 'Version file modified along with other files. To Change version, no other file should be modified'
	  exit 1;
  fi
  if (( $(echo "$initialVersion > $finalVersion" |bc -l) ))
  then
	  echo 'Version number is not properly incremented'
	  exit 1;
  fi
fi
