#!/bin/bash

# Ensure /data is valid
[ -f /data ] && rm /data
mkdir -p /data/etc /data/var/lib/pufferpanel/servers

# Remove default paths and symlink to /data
rm -rf /etc/pufferpanel
ln -s /data/etc /etc/pufferpanel

rm -rf /var/lib/pufferpanel/servers
mkdir -p /data/var/lib/pufferpanel/servers
ln -s /data/var/lib/pufferpanel/servers /var/lib/pufferpanel/servers

# Copy default config.json if it doesn't exist
if [ ! -f "/data/config.json" ]; then
  echo "[INFO] Copying default config.json to /data"
  cp /defaults/config.json /data/etc
fi

# Copy default email templates if missing
if [ ! -d "/data/email" ]; then
  echo "[INFO] Copying email templates to /data"
  cp -r /pufferpanel/email /data/
fi

# Copy default www files if missing
if [ ! -d "/data/www" ]; then
  echo "[INFO] Copying www files to /data"
  cp -r /pufferpanel/www /data/
fi

# Create admin user if DB is missing
if [ ! -f /data/etc/database.db ]; then
    echo "[INFO] Initializing database and creating admin user..."
    /pufferpanel/pufferpanel run --workDir /data/etc &
    sleep 3
    pkill -f "pufferpanel run"
    /pufferpanel/pufferpanel user add \
        --workDir /data/etc \
        --name admin \
        --email admin@hassio.com \
        --password hassio \
        --admin
fi

# Run PufferPanel
exec /pufferpanel/pufferpanel run --workDir /data/etc
