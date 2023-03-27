#!/bin/bash

DIR=.
NAME=cache
NAMESPACE=apiconfig

usage() {
  echo "Usage: $0 [--update] [--canary] [--install] [--uninstall] [--weight <percentage>] [--version <version>]" 1>&2;
  echo ""
  echo "Options:"
  echo "--update                Run helm dep update before installing."
  echo "--canary                Install canary version of the application."
  echo "--install               Install the application."
  echo "--uninstall             Uninstall the application."
  echo "--weight <percentage>   Specify a weight percentage for the canary version."
  echo "--version <version>     Specify a version for the deploy."
  exit 1;
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --update)
            update=1
            ;;
        --canary)
            canary=1
            ;;
        --install)
            install=1
            ;;
        --uninstall)
            uninstall=1
            ;;
        --weight)
            shift
            weight="$1"
            ;;
        --version)
            shift
            version="$1"
            ;;
        -h|--help)
            usage
            exit 0
            ;;

        *)
            echo "Unknown parameter passed: $1" >&2
            exit 1
            ;;
    esac
    shift
done

if [ "$install" == 1 ]; then
  if [ ! -n "$version" ]; then
    echo "Error: Version parameter required with --install." >&2
    exit 1
  fi
fi

if [ -n "$update" ]; then
  echo "Updating dependencies"
  helm dep update $DIR
fi

if [ "$install" == 1 ]; then
  if [ "$canary" == 1 ]; then
    echo "Installing canary version $version"
    helm upgrade --dry-run --namespace $NAMESPACE --install --values $DIR/values-dev.yaml \
      --set pagopamicroservice2.enabled=false \
      --set pagopamicroservice1.image.tag=$version \
      --set pagopamicroservice1.canaryDelivery.create="true" \
      $NAME-canary $DIR
    exit 0
  else
    echo "Installing stable version $version"
    helm upgrade --dry-run --namespace $NAMESPACE --install --values $DIR/values-dev.yaml \
      --set pagopamicroservice2.enabled=false \
      --set pagopamicroservice1.image.tag=$version \
      $NAME $DIR
    exit 0
  fi
fi

if [ "$uninstall" == 1 ]; then
  if [ "$canary" == 1 ]; then
    echo "Uninstalling canary"
    helm uninstall --dry-run --namespace $NAMESPACE --wait $NAME-canary
  else
    echo "Uninstalling stable"
    helm uninstall  --dry-run --namespace $NAMESPACE --wait $NAME
  fi
fi

exit 0
