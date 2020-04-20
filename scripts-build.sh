#!/bin/bash

USERNAME=${1}
PASSWORD=${2}

chmod +x ./gradlew
./gradlew -Pbuild.user="${USERNAME}" -Pbuild.password="${PASSWORD}" build
