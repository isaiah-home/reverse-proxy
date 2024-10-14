# Start from the official GoAccess Docker image
FROM allinurl/goaccess:1.9.3

# Set the environment variable for the MaxMind license key (optional)
ARG MAXMIND_LICENSE_KEY

COPY download-geo.sh /usr/local/bin/download-geo.sh
RUN  chmod +x /usr/local/bin/download-geo.sh && \
     /usr/local/bin/download-geo.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN  chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
