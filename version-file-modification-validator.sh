#!/bin/bash

ref1=$1
ref2=$2

echo "Checking Version File is Modified"
numberOfFilesModified=$(git diff --name-only "$ref1..$ref2" | wc -l)
isVersionFileModified=$(git diff --name-only "$ref1..$ref2" version.txt | wc -l)

echo $numberOfFilesModified
echo $isVersionFileModified

[ $numberOfFilesModified -gt 1 ] && [ $isVersionFileModified  -eq 1 ] &&  { echo 'Version file modified along with other files. To Change version, no other file should be modified' ; exit 1; }
