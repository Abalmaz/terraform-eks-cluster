#!/bin/sh
cd ../../app
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
docker build -t ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:${IMAGE_TAG} .
docker push ${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPO}:${IMAGE_TAG}