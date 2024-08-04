#!/bin/bash

LOCK_FILE=/var/lock/rsync-balmung

RSYNC_OPTIONS="-avz --force --partial"

if [ -f "$LOCK_FILE" ]; then
	echo "Lock already held. Exiting."
	exit 0
fi

touch $LOCK_FILE
echo "Running rsync"

rsync $RSYNC_OPTIONS /Balmung/* root@apollo:/mnt/orpheus/backup/Odin/Balmung
/root/uptime-push.sh XlWDOKszIN

echo "Rsync completed"

rm $LOCK_FILE
