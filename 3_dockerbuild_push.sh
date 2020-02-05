#!/bin/bash

mvn -DskipTests clean package -Pnative -Dquarkus.native.container-build=true

# get the build artifact name 
ARTIFACT_NAME=$(mvn org.apache.maven.plugins:maven-help-plugin:3.1.1:evaluate -Dexpression=project.build.finalName -q -DforceStdout)
ARTIFACT_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:3.1.1:evaluate -Dexpression=project.version -q -DforceStdout)

IMAGE_NAME=${APP_NAME:-"dev.local/rhdevelopers/$ARTIFACT_NAME:$ARTIFACT_VERSION"}

docker build -t $IMAGE_NAME -f src/main/docker/Dockerfile .

docker login quay.io

docker tag $IMAGE_NAME quay.io/rhdevelopers/$ARTIFACT_NAME:$ARTIFACT_VERSION

docker push quay.io/rhdevelopers/$ARTIFACT_NAME:$ARTIFACT_VERSION

