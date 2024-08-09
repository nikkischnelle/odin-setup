podman exec -u 33 -i nextcloud /bin/bash -c "php occ db:add-missing-indices"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set overwritehost --value=cloud.queercrew.de"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set trusted_domains 0 --value=cloud.queercrew.de"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set overwriteprotocol --value=https"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set overwrite.cli.url --value=https://cloud.queercrew.de"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set maintenance_window_start --type=integer --value=3"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set default_phone_region --value=DE"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set enabledPreviewProviders 0 --value='OC\\Preview\\Imaginary'"

podman exec -u 33 -i nextcloud /bin/bash -c "php occ config:system:set preview_imaginary_url --value='http://imaginary-nextcloud:9000'"
