#!/bin/bash


baseVersion=$(head -n 1 version.txt)
baseVersion=`echo $baseVersion | sed 's/\\r//g'`
[[ $baseVersion =~ ^[0-9]+\.[0-9]+$ ]] || (echo "The pattern <number(s)>.<number(s)> is not met" && exit 1)
[[ $baseVersion =~ ^0\.0$ ]] && (echo "The version can not be 0.0" && exit 1)
[[ $baseVersion =~ ^0[0-9]+\. ]] && (echo "The major version can not be prefixed with 0" && exit 1)
[[ $baseVersion =~ \.0[0-9]+ ]] && (echo "The minor version can not be prefixed with 0" && exit 1)
buildVersion=$(git rev-list $(git log  -n 1 --format=format:%H version.txt)..HEAD --count)
version="$baseVersion.$buildVersion"
if [ "$buildVersion" != "0" ]
then
	version="$version-$(git log -n1 --format=format:"%H")"
fi
echo $version

