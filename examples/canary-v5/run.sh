rm Chart.lock
rm -R charts
helm dependency build
helm upgrade --namespace apiconfig   --install --values ./values-dev.yaml   --wait --timeout 5m0s  delete-me ./
