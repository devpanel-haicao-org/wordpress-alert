#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (C) 2021 DevPanel
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation version 3 of the
# License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# For GNU Affero General Public License see <https://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------

STATIC_FILES_PATH="$WEB_ROOT/wp-content/uploads/"

#Create static directory
if [ ! -d "$STATIC_FILES_PATH" ]; then
  mkdir -p $STATIC_FILES_PATH
fi

#== Generate WordPress salt keys
echo 'Generate WordPress authentication keys...'
SALT_KEYS=$(wp config shuffle-salts 2>/dev/null || true)

# Securing file permissions and ownership
[[ ! -d $STATIC_FILES_PATH ]] && sudo mkdir --mode 775 $STATIC_FILES_PATH || sudo chmod 775 -R $STATIC_FILES_PATH

#== Extract static files
if ! wp core is-installed 2>/dev/null; then
  if [[ -f "$APP_ROOT/.devpanel/dumps/files.tgz" ]]; then
    echo  'Extract static files ...'
    sudo mkdir -p $STATIC_FILES_PATH
    sudo tar xzf "$APP_ROOT/.devpanel/dumps/files.tgz" -C $STATIC_FILES_PATH
    sudo rm -rf $APP_ROOT/.devpanel/dumps/files.tgz
  fi

  #== Import mysql files
  if [[ -f "$APP_ROOT/.devpanel/dumps/db.sql.gz" ]]; then
    echo  'Import mysql file ...'
    gunzip -c "$APP_ROOT/.devpanel/dumps/db.sql.gz" | wp db import -
  fi
fi