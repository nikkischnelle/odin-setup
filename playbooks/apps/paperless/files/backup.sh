cd $HOME
BASE=/Balmung/backup/apps/paperless

podman exec paperless-app document_exporter /usr/src/paperless/export

podman unshare rsync -a --delete /Gungnir/apps/paperless --exclude data/kuma.db* --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
