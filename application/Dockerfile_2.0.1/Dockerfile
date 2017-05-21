# Dockerfile for FileShelter (https://github.com/epoupon/fileshelter)

# Define base image and maintainer
FROM debian:stretch-slim
LABEL maintainer "Paul Galow (https://github.com/paulgalow)" \
      fileshelter_version "v2.0.1"

# Ser Dockerfile arguments
ARG fileshelter_src_url="https://github.com/epoupon/fileshelter/archive/v2.0.1.tar.gz"
ARG fileshelter_src_folder="fileshelter-2.0.1"
ARG container_user="fileshelter"
ARG app_dir="/var/fileshelter"
ARG web_dir="/usr/share/fileshelter/"
ARG build_packages="autoconf automake build-essential ca-certificates curl"

# Create unprivileged group and user
RUN groupadd -r "$container_user" -g 1000 \
    && useradd -u 1000 -r -g "$container_user" "$container_user"

# Install libraries / dependencies
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
      libboost-dev \
      libwtdbosqlite-dev \
      libwthttp-dev \
      libwtdbo-dev \
      libwt-dev \
      libconfig++-dev \
      libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy project repository to container and install FileShelter
WORKDIR "$app_dir"

# Build Fileshelter application
RUN apt-get update \
    && apt-get -y install --no-install-recommends $build_packages \
    && curl \
      --silent \
      --show-error \
      --fail \
      --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
      -o - \
      "$fileshelter_src_url" \
    | tar \
      --no-same-owner \
      -C "${app_dir}" \
      -xz "$fileshelter_src_folder"/ \
    && cd "$fileshelter_src_folder" \
    && autoreconf -vfi \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && make install clean \
    && cd ../ \
    && rm -rf "${app_dir}/${fileshelter_src_folder}/" \
    # Clean up and prune image
    && apt-get -y purge --auto-remove $build_packages \
    && rm -rf /var/lib/apt/lists/* \
    # Forward logs to Docker
    && ln -sf /dev/stdout "${app_dir}/fileshelter.log" \
    # Assign app directory ownership to unprivileged user
    && chown -R "$container_user":"$container_user" "$app_dir" "$web_dir"

# Run application
VOLUME "$app_dir"
EXPOSE 5091
USER "$container_user"
ENTRYPOINT ["/usr/bin/fileshelter"]
