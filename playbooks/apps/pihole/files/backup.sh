cd $HOME
BASE=/Balmung/backup/apps/pihole

podman unshare rsync -a --delete /Gungnir/apps/pihole --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
