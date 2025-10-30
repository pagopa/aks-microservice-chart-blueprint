#!/usr/bin/env bash
rm Chart.lock
rm -R charts
helm dependency build
helm template --values ./values-dev.yaml   umberto-init-container ./
helm upgrade --namespace diego  --install --values ./values-dev.yaml   --wait --timeout 5m0s  umberto-init-container ./
