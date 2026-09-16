#!/usr/bin/env bash

set -euo pipefail

chart_dir="$(cd "$(dirname "$0")/../../charts/microservice-chart" && pwd)"

render_chart() {
  helm template init-env-test "$chart_dir" \
    --set 'envConfig.APPLICATION_NORMAL=value' \
    --set 'envSecret.APPLICATION_PASSWORD=application-password' \
    --set 'initContainers[0].name=example-init' \
    --set 'initContainers[0].image.repository=busybox' \
    --set 'initContainers[0].image.tag=latest' \
    --set 'initContainers[0].image.pullPolicy=IfNotPresent' \
    --set 'initContainers[0].tmpVolumeMount.create=false' \
    "$@"
}

render_init_container() {
  render_chart "$@" | sed -n '/initContainers:/,/^[[:space:]]*volumes:/p'
}

assert_contains() {
  local rendered="$1"
  local expected="$2"

  if ! grep -Fq -- "$expected" <<<"$rendered"; then
    printf 'Expected initContainers block to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

assert_not_contains() {
  local rendered="$1"
  local unexpected="$2"

  if grep -Fq -- "$unexpected" <<<"$rendered"; then
    printf 'Expected initContainers block not to contain: %s\n' "$unexpected" >&2
    exit 1
  fi
}

application_only_rendered="$(render_init_container)"
assert_not_contains "$application_only_rendered" '          env:'
assert_not_contains "$application_only_rendered" 'APPLICATION_NORMAL'
assert_not_contains "$application_only_rendered" 'APPLICATION_PASSWORD'

rendered_chart="$(render_chart \
  --set 'initContainerEnvConfig.INIT_NORMAL=value' \
  --set 'initContainerEnvSecret.INIT_PASSWORD=init-password')"
rendered="$(sed -n '/initContainers:/,/^[[:space:]]*volumes:/p' <<<"$rendered_chart")"
assert_contains "$rendered" '- name: INIT_NORMAL'
assert_contains "$rendered" 'name: init-env-test-microservice-chart-init'
assert_contains "$rendered" 'key: INIT_NORMAL'
assert_contains "$rendered" '- name: INIT_PASSWORD'
assert_contains "$rendered" 'key: init-password'
assert_not_contains "$rendered" 'APPLICATION_NORMAL'
assert_not_contains "$rendered" 'APPLICATION_PASSWORD'
init_config_map="$(awk 'BEGIN { RS="---" } /kind: ConfigMap/ && /name: init-env-test-microservice-chart-init/ { print }' <<<"$rendered_chart")"
assert_contains "$init_config_map" 'INIT_NORMAL: value'
secret_provider="$(awk 'BEGIN { RS="---" } /kind: SecretProviderClass/ { print }' <<<"$rendered_chart")"
assert_contains "$secret_provider" 'key: init-password'
assert_contains "$secret_provider" 'objectName: init-password'

canary_rendered="$(render_init_container \
  --set 'initContainerEnvConfig.INIT_NORMAL=value' \
  --set 'initContainerEnvSecret.INIT_PASSWORD=init-password' \
  --set 'canaryDelivery.create=true' \
  --set 'canaryDelivery.image.repository=busybox' \
  --set 'canaryDelivery.image.tag=latest' \
  --set 'canaryDelivery.envConfig.CANARY_NORMAL=value' \
  --set 'canaryDelivery.envSecret.CANARY_PASSWORD=canary-password')"
assert_contains "$canary_rendered" '- name: INIT_NORMAL'
assert_contains "$canary_rendered" '- name: INIT_PASSWORD'
assert_not_contains "$canary_rendered" 'APPLICATION_NORMAL'
assert_not_contains "$canary_rendered" 'APPLICATION_PASSWORD'
assert_not_contains "$canary_rendered" 'CANARY_NORMAL'
assert_not_contains "$canary_rendered" 'CANARY_PASSWORD'

echo "init container environment rendering passed"
