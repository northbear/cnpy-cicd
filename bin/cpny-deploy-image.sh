#!/usr/bin/env bash

## set -vx

BASE_DIR=$(cd `dirname $0`; pwd )

WORK_DIR=$( realpath ${BASE_DIR}/cd-kustomization )

APP_ECR_REGISTRY=${1}
APP_TAG=${2}

cd "${WORK_DIR}"
kustomize edit set image ${APP_ECR_REGISTRY}:${APP_TAG}
# kustomize edit set image ${ECR_REPOSITORY}/webapp/web:0.1.0
