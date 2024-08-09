BASE=/Balmung/backup/apps/homeassistant

podman unshare rsync -a --delete /Gungnir/apps/homeassistant --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
