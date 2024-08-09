cd $HOME
BASE=/Balmung/backup/apps/jellyfin

podman unshare rsync -a --delete /Gungnir/apps/jellyfin --exclude jellyfin-config/transcodes --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
