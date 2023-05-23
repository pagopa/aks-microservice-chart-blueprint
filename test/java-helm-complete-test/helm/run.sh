#!/bin/bash

echo "🚀 start helm installation"

helm dep build && helm template . -f values-devopslab-dev.yaml  --debug

echo "✅ Tempalte helm chart"

helm dep build && helm upgrade --namespace diego \
  --install --values values-devopslab-dev.yaml \
  --wait --timeout 2m0s java-helm-complete-test .

echo "✅ Completed helm installation"
