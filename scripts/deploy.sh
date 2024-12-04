#!/bin/bash

set -e  # Exit the script if any command fails

### How to use
#
# deploy.sh <values yaml file> <namespace > <cluster k8s name> <app name or release name>
# deploy.sh values.yaml mil cstar-d-weu-dev01-aks status
#
#

# Function to handle errors
handle_error() {
    echo "❌ Error: $1" >&2
    exit 1
}

# Parameter verification
VALUES_FILE_NAME=$1
CLUSTER_NAME=$2  # New parameter for cluster name
APP_NAME=$3
SECRET_NAME="testit-workload-identity-client-id"

if [ -z "$VALUES_FILE_NAME" ] || [ -z "$APP_NAME" ] || [ -z "$CLUSTER_NAME" ]; then
    handle_error "All parameters are required: VALUES_FILE_NAME NAMESPACE APP_NAME CLUSTER_NAME"
fi

#
# VALUES
#
NAMESPACE=$(yq eval '.microservice-chart.namespace' "$VALUES_FILE_NAME")

if [ -z "$NAMESPACE" ]; then
    echo "Errore: Impossible to read the namespace"
    exit 1
fi

#
# 🔒 KV
#
KEYVAULT_NAME=$(yq eval '.microservice-chart.keyvault.name' "$VALUES_FILE_NAME")

if [ -z "$KEYVAULT_NAME" ]; then
    echo "Errore: Impossibile leggere il nome del Key Vault dal file YAML"
    exit 1
fi

CLIENT_ID=$(az keyvault secret show --name "$SECRET_NAME" --vault-name "$KEYVAULT_NAME" --query "value" -o tsv)

# Verifica che il segreto sia stato recuperato correttamente
if [ -z "$CLIENT_ID" ]; then
    echo "Errore: Impossible to read the secret value"
    exit 1
fi

#
# K8s
#
if ! command -v kubectl &> /dev/null; then
    handle_error "kubectl is not installed. Please install it and try again."
fi

if ! command -v helm &> /dev/null; then
    handle_error "Helm is not installed. Please install it and try again."
fi

echo "🔄 Switching Kubernetes context to cluster $CLUSTER_NAME"
if ! kubectl config use-context "$CLUSTER_NAME"; then
    handle_error "Unable to switch context to $CLUSTER_NAME. Make sure the cluster exists in your kubeconfig."
fi

#
# ⎈ HELM
#
echo "🪚 Deleting charts folder"
rm -rf charts || handle_error "Unable to delete charts folder"

echo "🔨 Starting Helm Template"
helm dep build && \
helm template . -f "$VALUES_FILE_NAME" \
  --set microservice-chart.azure.workloadIdentityClientId="$CLIENT_ID" \
  --debug

echo "🚀 Launch helm deploy"
# Execute helm upgrade/install command and capture output and exit code
helm upgrade --namespace "$NAMESPACE" \
    --install \
    --set microservice-chart.azure.workloadIdentityClientId="$CLIENT_ID" \
    --values "$VALUES_FILE_NAME" \
    --wait --debug --timeout 3m0s "$APP_NAME" .

exit_code=$?

# Check the command result
if [ $exit_code -ne 0 ]; then
    handle_error "Failed to upgrade/install Helm chart"
else
    echo "✅ Release installation completed successfully"
fi
