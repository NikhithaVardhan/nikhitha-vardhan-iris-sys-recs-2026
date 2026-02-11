#!/bin/bash

BACKUP_DIR="/backups"

while true
do
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
  ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"

  tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" \
      /data \
      /configs

  echo "Backup created at $TIMESTAMP"

  sleep 1800
done
