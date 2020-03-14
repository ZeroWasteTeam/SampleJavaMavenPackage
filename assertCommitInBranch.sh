#!/bin/bash

set -e

COMMIT=$1
BRANCH=$2

test $(git log ${BRANCH} --format=format:%H | grep ${COMMIT} | wc -l) -eq 1 || exit 1

