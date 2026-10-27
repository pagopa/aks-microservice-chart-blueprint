#!/bin/bash

../../../scripts/deploy.sh values-devopslab-dev.yaml dvopla-d-itn-dev-aks v8-keda-multiple-trigger-auth-test

# No envSecret/initContainerEnvSecret in this test (PAYMCLOUD-1381): no SecretProviderClass must be created
if kubectl get secretproviderclass --namespace testit v8-keda-multiple-trigger-auth-test-microservice-chart >/dev/null 2>&1; then
  echo "❌ SecretProviderClass created without secrets" >&2
  exit 1
fi
echo "✅ no SecretProviderClass without secrets"
