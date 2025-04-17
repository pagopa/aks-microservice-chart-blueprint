#!/bin/bash

echo "🚀 v2-java-helm-complete-test"
pushd v2-java-helm-complete-test/helm || exit
sh run.sh
popd || exit
echo "✅ v2-java-helm-complete-test"

echo "🚀 v7-java-helm-basic-test"
pushd v7-java-helm-basic-test/helm || exit
sh run.sh
popd || exit
echo "✅ v7-java-helm-basic-test"

echo "🚀 v7-java-helm-complete-test"
pushd v7-java-helm-complete-test/helm || exit
sh run.sh
popd || exit
echo "✅ v7-java-helm-complete-test"
