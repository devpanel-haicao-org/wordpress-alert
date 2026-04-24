#!/usr/bin/env bash
if [ -n "${DEBUG_SCRIPT:-}" ]; then
  set -x
fi
set -eu -o pipefail
cd $APP_ROOT

LOG_FILE="logs/init-$(date +%F-%T).log"
exec > >(tee $LOG_FILE) 2>&1

TIMEFORMAT=%lR

#== Remove root-owned files.
echo
echo Remove root-owned files.
time sudo rm -rf lost+found

#== Download WordPress if not already installed.
echo
if [ ! -f wp-load.php ]; then
  echo 'Download WordPress.'
  time wp core download --version=latest
  echo
fi

#== Create wp-config.php.
echo
if [ ! -f wp-config.php ]; then
  echo 'Create wp-config.php.'
  time wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="${DB_HOST}:${DB_PORT}"
  echo

  # Include DevPanel settings override at the top of wp-config.php.
  INCLUDE_LINE="require_once dirname(__FILE__) . '/.devpanel/wp-config.devpanel.php';"
  sed -i "s|<?php|<?php\n${INCLUDE_LINE}\n|g" wp-config.php
  echo "Included wp-config.devpanel.php into wp-config.php"
  echo
fi

#== Install WordPress.
echo
# Determine the site URL for installation.
INSTALL_URL="http://localhost"
if [ -n "${DP_HOSTNAME:-}" ]; then
  INSTALL_URL="https://${DP_HOSTNAME}"
fi

if ! wp core is-installed 2>/dev/null; then
  echo "Install WordPress with URL: ${INSTALL_URL}"
  time wp core install \
    --url="${INSTALL_URL}" \
    --title="WordPress Site" \
    --admin_user="admin" \
    --admin_password="admin" \
    --admin_email="admin@example.com"
else
  echo 'Update database.'
  time wp core update-db
fi

# ==============================================================================
# SET UP ALERT BAR (DYNAMIC DATA FETCHING & INJECTION)
# ==============================================================================
echo
time source .devpanel/modules/alert-bar/setup.sh
echo
# ==============================================================================

#== Warm up caches.
echo
echo 'Flush rewrite rules.'
time wp rewrite flush
echo
echo 'Populate caches.'
time .devpanel/warm

#== Finish measuring script time.
INIT_DURATION=$SECONDS
INIT_HOURS=$(($INIT_DURATION / 3600))
INIT_MINUTES=$(($INIT_DURATION % 3600 / 60))
INIT_SECONDS=$(($INIT_DURATION % 60))
printf "\nTotal elapsed time: %d:%02d:%02d\n" $INIT_HOURS $INIT_MINUTES $INIT_SECONDS