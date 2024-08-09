#!/bin/bash
cd $HOME
BASE=/Balmung/backup/apps/nextcloud

source $HOME/nextcloud.env

podman exec -u 33 -i nextcloud php occ maintenance:mode --on
podman exec -i postgres-nextcloud /bin/bash -c "PGPASSWORD=$POSTGRES_PASSWORD pg_dump --port ${POSTGRES_PORT:-5432} -U $POSTGRES_USER $POSTGRES_DB" > $HOME/postgres_dump

podman volume export pgdata > $HOME/pgdata_volume_export.tar.gz
podman volume export redisdata > $HOME/redisdata_volume_export.tar.gz

podman unshare rsync -a --delete /Gungnir/apps/nextcloud --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

podman exec -u 33 -i nextcloud php occ maintenance:mode --off

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
