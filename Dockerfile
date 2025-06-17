FROM pufferpanel/pufferpanel:latest

# Copy default config files
COPY rootfs/defaults /defaults

# Copy startup script
COPY rootfs/run.sh /run.sh
RUN chmod +x /run.sh

# Override entrypoint to run our script
ENTRYPOINT ["/run.sh"]
