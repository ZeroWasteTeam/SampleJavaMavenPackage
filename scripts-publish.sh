#!/bin/bash

gradle -Pgpr.repo="https://maven.pkg.github.com/ZeroWasteTeam/SampleJavaMavenPackage" -Pgpr.user="${1}" -Pgpr.key="${2}" -Pgpr.version="${3}" publish

