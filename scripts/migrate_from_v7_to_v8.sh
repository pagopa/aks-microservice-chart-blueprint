#!/bin/bash

# Script: migrate_from_v7_to_v8.sh
# Description: This script helps migrate KEDA ScaledObjects from v7 to v8 by properly
# labeling and annotating them to support Helm manifest deletion.
#
# Purpose: To ensure proper Helm management of KEDA resources by adding required
# Helm labels and annotations to existing ScaledObjects.
#
# Usage: ./migrate_from_v7_to_v8.sh <name> <release_name> <namespace>

print_help() {
  echo "Usage: $0 <name> <release_name> <namespace>"
  echo
  echo "Description:"
  echo "  This script adds required Helm labels and annotations to an existing KEDA ScaledObject"
  echo "  to ensure proper management by Helm during upgrades and deletions."
  echo
  echo "Parameters:"
  echo "  <name>           The name of the ScaledObject to be migrated"
  echo "  <release_name>   The Helm release name that manages the ScaledObject"
  echo "  <namespace>      The Kubernetes namespace where the ScaledObject is deployed"
  echo
  echo "Example:"
  echo "  $0 my-scaledobject my-release my-namespace"
  echo
  echo "Note: After running this script, verify the migration using:"
  echo "  helm get manifest <release_name> -n <namespace> | grep ScaledObject -A 10"
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  print_help
  exit 0
fi

if [[ $# -ne 3 ]]; then
  echo "Error: Invalid number of parameters."
  print_help
  exit 1
fi

name="$1"
release_name="$2"
namespace="$3"

label_and_annotate_scaledobject() {
  kubectl label scaledobject "$name" -n "$namespace" app.kubernetes.io/instance="$release_name" --overwrite
  kubectl label scaledobject "$name" -n "$namespace" app.kubernetes.io/managed-by=Helm --overwrite
  kubectl annotate scaledobject "$name" -n "$namespace" meta.helm.sh/release-name="$release_name" --overwrite
  kubectl annotate scaledobject "$name" -n "$namespace" meta.helm.sh/release-namespace="$namespace" --overwrite
}

label_and_annotate_scaledobject
