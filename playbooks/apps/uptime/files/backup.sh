cd $HOME
BASE=/Balmung/backup/apps/uptime

podman unshare rsync -a --delete /Gungnir/apps/uptime --exclude data/kuma.db --exclude data/kuma.db-shm --exclude data/kuma.db-whl --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

sqlite3 data/kuma.db ".backup '/Balmung/backup/apps/uptime/data/kuma.db'"

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
