#!/bin/bash
# Deploys the azureFile test.
# 1. creates/updates the Secret with the storage account credentials (keys azurestorageaccountname/azurestorageaccountkey)
# 2. deploys the release with scripts/deploy.sh
# 3. prints the checks
#
# Usage: STORAGE_ACCOUNT_NAME=<account> STORAGE_SUBSCRIPTION=<subscription id or name> RESOURCE_GROUP=<resource group> ./deploy.sh
set -euo pipefail

CLUSTER_NAME="dvopla-d-itn-dev-aks"
NAMESPACE="testit"
APP_NAME="v8-azure-file-test"
SECRET_NAME="v8-azure-file-test-storage"

: "${STORAGE_ACCOUNT_NAME:?set STORAGE_ACCOUNT_NAME}"
: "${RESOURCE_GROUP:?set RESOURCE_GROUP (the storage account resource group)}"
: "${STORAGE_SUBSCRIPTION:?set STORAGE_SUBSCRIPTION (the storage account subscription)}"

if grep -q REPLACE_WITH_SHARE_NAME values-devopslab-dev.yaml; then
  echo "❌ set azureFile.mounts[].shareName in values-devopslab-dev.yaml" >&2
  exit 1
fi

kubectl config use-context "$CLUSTER_NAME"

echo "🔑 Creating Secret $SECRET_NAME from storage account $STORAGE_ACCOUNT_NAME"
STORAGE_ACCOUNT_KEY=$(az storage account keys list --account-name "$STORAGE_ACCOUNT_NAME" \
  --subscription "$STORAGE_SUBSCRIPTION" --resource-group "$RESOURCE_GROUP" --query "[0].value" -o tsv)
kubectl create secret generic "$SECRET_NAME" --namespace "$NAMESPACE" \
  --from-literal=azurestorageaccountname="$STORAGE_ACCOUNT_NAME" \
  --from-literal=azurestorageaccountkey="$STORAGE_ACCOUNT_KEY" \
  --dry-run=client -o yaml | kubectl apply -f -

../../../scripts/deploy.sh values-devopslab-dev.yaml "$CLUSTER_NAME" "$APP_NAME"

POD=$(kubectl get pods -n "$NAMESPACE" -l "app.kubernetes.io/instance=$APP_NAME" -o jsonpath='{.items[0].metadata.name}')
echo "🔎 Init container mount (share listing written by the init container):"
kubectl exec -n "$NAMESPACE" "$POD" -- cat /mnt/listing/share.txt
echo "🔎 Main container mount (/mnt/share):"
kubectl exec -n "$NAMESPACE" "$POD" -- ls -la /mnt/share
echo "🔎 Read-only check (must fail):"
kubectl exec -n "$NAMESPACE" "$POD" -- touch /mnt/share/should-fail && echo "❌ share is writable" || echo "✅ share is read-only"
