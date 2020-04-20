#!/bin/bash

REPO=${1}
USERNAME=${2}
PASSWORD=${3}

./gradlew -Pgpr.repo="https://maven.pkg.github.com/${REPO}" -Pgpr.user="${USERNAME}" -Pgpr.key="${PASSWORD}" -Pgpr.version="${4}" publish

