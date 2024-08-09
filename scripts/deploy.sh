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
NAMESPACE=$2
CLUSTER_NAME=$3  # New parameter for cluster name
APP_NAME=$4

if [ -z "$VALUES_FILE_NAME" ] || [ -z "$NAMESPACE" ] || [ -z "$APP_NAME" ] || [ -z "$CLUSTER_NAME" ]; then
    handle_error "All parameters are required: VALUES_FILE_NAME NAMESPACE APP_NAME CLUSTER_NAME"
fi

echo "🪚 Delete charts folder"
rm -rf charts || true

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    handle_error "kubectl is not installed. Please install it and try again."
fi

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    handle_error "Helm is not installed. Please install it and try again."
fi

echo "🔄 Switching Kubernetes context to cluster $CLUSTER_NAME"
if ! kubectl config use-context "$CLUSTER_NAME"; then
    handle_error "Unable to switch context to $CLUSTER_NAME. Make sure the cluster exists in your kubeconfig."
fi

echo "🪚 Deleting charts folder"
rm -rf charts || handle_error "Unable to delete charts folder"

echo "🔨 Starting Helm Template"
helm dep build && helm template . -f "$VALUES_FILE_NAME"  --debug


echo "🚀 Launch helm deploy"
# Execute helm upgrade/install command and capture output and exit code
helm upgrade --namespace "$NAMESPACE" \
    --install --values "$VALUES_FILE_NAME" \
    --wait --timeout 3m0s "$APP_NAME" .

exit_code=$?

# Check the command result
if [ $exit_code -ne 0 ]; then
    handle_error "Failed to upgrade/install Helm chart"
else
    echo "✅ Release installation completed successfully"
fi
