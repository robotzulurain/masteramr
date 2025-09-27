#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

echo "Installing Python dependencies..."
pip install -r requirements.txt

echo "Running Django migrations..."
python manage.py migrate --no-input

echo "Collecting static files..."
python manage.py collectstatic --no-input

# Bootstrap admin user only when CREATE_ADMIN_USER=true
if [ "${CREATE_ADMIN_USER:-}" = "true" ]; then
  echo "Creating admin user from environment variables..."
  python manage.py create_admin_user \
    --username "${ADMIN_USERNAME:-admin}" \
    --email "${ADMIN_EMAIL:-admin@example.com}" \
    --password "${ADMIN_PASSWORD:-ChangeMeNow!}" || true
else
  echo "CREATE_ADMIN_USER not set or false; skipping admin creation."
fi
