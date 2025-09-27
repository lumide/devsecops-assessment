#!/usr/bin/env bash
set -euo pipefail

RELEASE=${1:-}
NAMESPACE=${2:-default}
REVISION=${3:-}

if [ -z "$RELEASE" ]; then
  echo "Usage: rollback.sh <release> <namespace> [revision]"
  exit 2
fi

if [ -z "$REVISION" ]; then
  echo "Rolling back $RELEASE in $NAMESPACE to previous revision"
  helm rollback "$RELEASE" -n "$NAMESPACE"
else
  echo "Rolling back $RELEASE in $NAMESPACE to revision $REVISION"
  helm rollback "$RELEASE" "$REVISION" -n "$NAMESPACE"
fi

echo "If DB restore required, restore RDS snapshot manually or via runbook."
