#!/usr/bin/env bash

# set -xv

BASE_DIR=$( cd `dirname $0`; pwd )
WORK_DIR=$( realpath "${BASE_DIR}/.." )

CPNY_TF_CONF=$( realpath "${WORK_DIR}/../cpny-terraform-infra" )

[[ -d "${CPNY_TF_CONF}" ]] || { echo "Error: a TF configuration doesn't exist: ${CPNY_RF_CONF}"; exit 1; }

EKS_CLUSTER_NAME=$( cd "${CPNY_TF_CONF}"; terraform output -json | jq -r '.eks_cluster_name.value' )

echo "Configure a cluster: $[EKS_CLUSTER_NAME]"

## Removing old related context
if kubectl config get-contexts | grep -q "${EKS_CLUSTER_NAME}"; then
    KC_CONTEXT=$( kubectl config get-contexts | grep "${EKS_CLUSTER_NAME}" | sed -E 's/^[\*] +(.+$)/\1/g' | awk '{ print $1 }' )
    KC_CLUSTER=$( kubectl config get-contexts | grep "${EKS_CLUSTER_NAME}" | sed -E 's/^[\*] +(.+$)/\1/g' | awk '{ print $2 }' )
    KC_USER=$(    kubectl config get-contexts | grep "${EKS_CLUSTER_NAME}" | sed -E 's/^[\*] +(.+$)/\1/g' | awk '{ print $3 }' )
    echo "Removing context ${KC_CONTEXT}..."
    kubectl config delete-context "${KC_CONTEXT}"
    kubectl config delete-user    "${KC_USER}"
    kubectl config delete-cluster "${KC_CLUSTER}"
fi

NEW_CONTEXT=$( aws eks update-kubeconfig --name "${EKS_CLUSTER_NAME}" | cut -f4 -d ' ' )
echo "Context ${NEW_CONTEXT} created"
if kubectl config get-contexts | grep -q "${NEW_CONTEXT}"; then
    kubectl config rename-context "${NEW_CONTEXT}" "${EKS_CLUSTER_NAME}"
else
    echo "Error: something went bad with configuring kubectl context"
    exit 1
fi
