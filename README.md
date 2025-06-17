# Pufferpanel-HASS-Addon
A addon for running pufferpanel on supervised HASS

## To install addon:
- Download repo and edit `config.yaml` to add ports for game servers. # Its configured for minecraft by default.
- Use SAMBA addon to copy addon folder to `/addons` on HAOS.
- In HAOS store, check for updates and then refresh page. Install Pufferpanel addon and run it.
- By default the addon creates a admin user `admin@hassio.com` password `hassio` but this can be changed in the `run.sh`.
- Login to webui at `haosip:8080`.

## Notes:
- Due to how Home Assistant OS Supervised addons work ports must be added via the `config.yaml` before install. The addon *should* store all server and user data at `/share/pufferpanel` so it will persist on reinstalls to allow for adding additional ports.
