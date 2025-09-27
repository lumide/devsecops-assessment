#!/usr/bin/env bash
set -euo pipefail

ENV=${1:-dev}
echo "$(date -u) - Running smoke tests for env=${ENV}"

# Map env to base host (adjust to your ingress/dns)
case "$ENV" in
  dev) BASE_URL="http://localhost:80" ;;       # for docker-compose local testing
  uat) BASE_URL="https://uat.api.example.com" ;;
  prod) BASE_URL="https://api.example.com" ;;
  dr) BASE_URL="https://dr.api.example.com" ;;
  *) BASE_URL="$ENV" ;;
esac

SERVICES=(payment-service account-service transaction-service)
for s in "${SERVICES[@]}"; do
  # change endpoint to match your service path if needed
  url="${BASE_URL}/${s}/actuator/health/readiness"
  echo "Checking ${s} -> ${url}"
  if ! curl --fail --silent --show-error --max-time 10 "${url}"; then
    echo "Smoke test failed for ${s} at ${url}"
    exit 3
  fi
done

echo "$(date -u) - All smoke tests passed for ${ENV}"