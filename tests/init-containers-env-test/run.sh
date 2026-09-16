#!/usr/bin/env bash

set -euo pipefail

chart_dir="$(cd "$(dirname "$0")/../../charts/microservice-chart" && pwd)"

render_init_container() {
  helm template init-env-test "$chart_dir" \
    --set 'envConfig.NORMAL=value' \
    --set 'envSecret.PASSWORD=password' \
    --set 'initContainers[0].name=example-init' \
    --set 'initContainers[0].image.repository=busybox' \
    --set 'initContainers[0].image.tag=latest' \
    --set 'initContainers[0].image.pullPolicy=IfNotPresent' \
    --set 'initContainers[0].tmpVolumeMount.create=false' \
    "$@" |
    sed -n '/initContainers:/,/^[[:space:]]*volumes:/p'
}

assert_contains() {
  local rendered="$1"
  local expected="$2"

  if ! grep -Fq -- "$expected" <<<"$rendered"; then
    printf 'Expected initContainers block to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

rendered="$(render_init_container)"
assert_contains "$rendered" '- name: NORMAL'
assert_contains "$rendered" 'key: NORMAL'
assert_contains "$rendered" '- name: PASSWORD'
assert_contains "$rendered" 'key: password'

canary_rendered="$(render_init_container \
  --set 'canaryDelivery.create=true' \
  --set 'canaryDelivery.image.repository=busybox' \
  --set 'canaryDelivery.image.tag=latest' \
  --set 'canaryDelivery.envConfig.CANARY_NORMAL=value' \
  --set 'canaryDelivery.envSecret.CANARY_PASSWORD=canary-password')"
assert_contains "$canary_rendered" '- name: NORMAL'
assert_contains "$canary_rendered" '- name: PASSWORD'
assert_contains "$canary_rendered" '- name: CANARY_NORMAL'
assert_contains "$canary_rendered" 'key: CANARY_NORMAL'
assert_contains "$canary_rendered" '- name: CANARY_PASSWORD'
assert_contains "$canary_rendered" 'key: canary-password'

echo "init container environment rendering passed"
