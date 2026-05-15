#!/bin/bash

# Simple script to template the chart and verify HAProxy Ingress
helm dependency build
helm template . -f values-devopslab-dev.yaml
