#!/bin/bash
set -e

# 'PUSER' AND 'APP_DIR' are environment
# variables defined in Dockerfile

if [ "$UID" = "0" ]; then
  chown -R "${PUSER}:${PUSER}" "$APP_DIR"
  exec gosu "${PUSER}" "$@"
fi

exec "$@"