#!/bin/bash

VALUES_FILE_NAME=$1
NAMESPACE=$2
APP_NAME=$3

echo "✂️ Delete charts folder"
rm -rf charts || true

echo "🚀 start helm installation"

helm dep build && helm template . -f "$VALUES_FILE_NAME"  --debug

echo "✅ Tempalte helm chart"

helm dep build && helm upgrade --namespace "$NAMESPACE" \
  --install --values "$VALUES_FILE_NAME" \
  --wait --timeout 3m0s "$APP_NAME" .

echo "✅ Completed helm installation"
