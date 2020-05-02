# Dockerfile for FileShelter (https://github.com/epoupon/fileshelter)

# Define base image and maintainer
FROM debian:buster-slim
LABEL maintainer "Paul Galow (https://github.com/paulgalow)" \
      fileshelter_version "latest"

# Ser Dockerfile arguments
ARG catalog_url="https://debian.poupon.io/apt/debian"
ARG gpg_key="epoupon.gpg.key"
ARG sources_list="epoupon.list"
ARG app_dir="/var/fileshelter"
ARG container_user="fileshelter"

# Install libraries / dependencies
RUN apt-get -q update \
    && apt-get -q -y install --no-install-recommends \
      ca-certificates \
      gnupg2 \
      wget \
    && wget -q -O - "${catalog_url}/${gpg_key}" | apt-key add - \
    && echo "deb ${catalog_url} buster main" > /etc/apt/sources.list.d/"${sources_list}" \
    && apt-get update \
    && apt-get -q -y install fileshelter \
    && apt-get -q -y purge wget gnupg2 ca-certificates \
    && apt-get -q -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    # Change container user and group id to avoid permissions issues
    && usermod -u 1000 "$container_user" \
    && groupmod -g 1000 "$container_user" \
    # Forward logs to Docker
    && ln -sf /dev/stdout "${app_dir}/fileshelter.log"

# Run application
VOLUME "$app_dir"
EXPOSE 5091
USER "$container_user"
ENTRYPOINT ["/usr/bin/fileshelter"]
