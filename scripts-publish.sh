#!/bin/bash

gradle -Pgpr.repo="https://maven.pkg.github.com/${1}" -Pgpr.user="${2}" -Pgpr.key="${3}" -Pgpr.version="${4}" publish

