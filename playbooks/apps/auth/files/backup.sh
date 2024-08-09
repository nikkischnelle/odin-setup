cd $HOME
BASE=/Balmung/backup/apps/auth

podman unshare rsync -a --delete /Gungnir/apps/auth --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

source $HOME/postgres.env
podman exec postgres-authentik bash -c "POSTGRES_PASSWORD=$POSTGRES_PASSWORD pg_dump -U $POSTGRES_USER $POSTGRES_DB" > $BASE/pgdump

podman volume export pgdata > $BASE/pgdata_volume_export.tar.gz
podman volume export redisdata > $BASE/redisdata_volume_export.tar.gz

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
