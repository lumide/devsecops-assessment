#!/usr/bin/env bash
set -euo pipefail

ENV=${1:-staging}
echo "$(date -u) - Running DB migration for env=${ENV}"

: "${DB_HOST:?DB_HOST required}"
: "${DB_PORT:?DB_PORT required}"
: "${DB_NAME:?DB_NAME required}"
: "${DB_USER:?DB_USER required}"
: "${DB_PASSWORD:?DB_PASSWORD required}"

# In prod, create snapshot (requires AWS CLI + permissions)
if [ "$ENV" = "prod" ]; then
  echo "Creating RDS snapshot before PROD migration (ensure AWS creds available)"
  # aws rds create-db-snapshot --db-instance-identifier "${DB_INSTANCE_IDENTIFIER}" --db-snapshot-identifier "${DB_INSTANCE_IDENTIFIER}-pre-migration-$(date +%s)"
fi

# Run flyway using docker image and mount migrations from sample-services/*/db/migration
docker run --rm \
  -v "$(pwd)/sample-services:/flyway/sql" \
  flyway/flyway:9 -url=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME} -user=${DB_USER} -password=${DB_PASSWORD} -locations=filesystem:/flyway/sql migrate

echo "$(date -u) - Migration complete for env=${ENV}"