#!/bin/bash

USERNAME=${1}
PASSWORD=${2}

chomod +x ./gradlew
./gradlew -Pbuild.user="${USERNAME}" -Pbuild.password="${PASSWORD}" build
