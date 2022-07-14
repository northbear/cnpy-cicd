#!/usr/bin/env bash

# set -xv

BASE_DIR=$( cd `dirname $0`; pwd )
WORK_DIR=$( realpath "${BASE_DIR}/.." )

CPNY_TF_CONF=$( realpath "${WORK_DIR}/../cpny-terraform-infra" )

[[ -d "${CPNY_TF_CONF}" ]] || { echo "Error: a TF configuration doesn't exist: ${CPNY_RF_CONF}"; exit 1; }

EKS_CLUSTER_NAME=$( cd "${CPNY_TF_CONF}"; terraform output -json | jq -r '.eks_cluster_name.value' )

if ! kubectl config current-context | grep -q "$EKS_CLUSTER_NAME"; then
    echo "Error: wrong k8s cluster context. It should be $EKS_CLUSTER_NAME"
    exit 1
fi

APP_MANIFESTS=$( realpath "${WORK_DIR}/manifests" )

kubectl apply -k "${APP_MANIFESTS}"
