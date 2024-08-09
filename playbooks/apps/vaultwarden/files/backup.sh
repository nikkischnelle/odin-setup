cd $HOME
BASE=/Balmung/backup/apps/vaultwarden

podman unshare rsync -a --delete /Gungnir/apps/vaultwarden --exclude data/kuma.db* --exclude=.cache --exclude=.config --exclude=.local --exclude=.zshenv /Balmung/backup/apps

DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/3008/bus systemctl --user stop vaultwarden
sqlite3 "$HOME/data/db.sqlite3" ".backup '$BASE/data/db.sqlite3'"
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/3008/bus systemctl --user start vaultwarden

mkdir -p $BASE/.config/containers
rsync -a $HOME/.config/containers/systemd $BASE/.config/containers
