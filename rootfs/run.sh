#!/bin/bash

set -e

# Ensure /data is valid and has required structure
[ -f /share/pufferpanel ] && rm /share/pufferpanel

# Create Temp Folders
mkdir -p /share/pufferpanel /share/pufferpanel/var /share/pufferpanel/etc /share/pufferpanel/temp /share/pufferpanel/temp/etc /share/pufferpanel/temp/var

# Copy files to temp folders
cp -r /etc/pufferpanel /share/pufferpanel/temp/etc
cp -r /var/lib/pufferpanel /share/pufferpanel/temp/var


# Replace /etc/pufferpanel with symlink to /share/pufferpanel/etc
rm -rf /etc/pufferpanel
ln -s /share/pufferpanel/etc /etc/pufferpanel

# Replace /var/lib/pufferpanel with symlink to /share/pufferpanel/
rm -rf /var/lib/pufferpanel
ln -s /share/pufferpanel/var /var/lib/pufferpanel


# Copy default config.json if not present
if [ ! -f "/share/pufferpanel/etc/config.json" ]; then
  echo "[INFO] Copying default config.json to /share/pufferpanel/etc"
  cp /defaults/config.json /share/pufferpanel/etc/
fi

# Remove temp folder
rm -r /share/pufferpanel/temp

# Only create admin user if they don't exist
if ! /pufferpanel/pufferpanel user list --workDir /share/pufferpanel/etc | grep -q admin@hassio.com; then
  echo "[INFO] Creating admin user..."
  /pufferpanel/pufferpanel user add \
    --workDir /share/pufferpanel/etc \
    --name admin \
    --email admin@hassio.com \
    --password hassio \
    --admin
fi


# Start PufferPanel with config in /share/pufferpanel/etc
exec /pufferpanel/pufferpanel run --workDir /pufferpanel/
