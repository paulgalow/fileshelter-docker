# Dockerfile for FileShelter (https://github.com/epoupon/fileshelter)

# Define base image and maintainer
FROM debian:buster-slim
LABEL maintainer "Paul Galow (https://github.com/paulgalow)" \
  fileshelter_version "latest"

# Ser Dockerfile arguments
ARG catalog_url="https://debian.poupon.io/apt/debian"
ARG gpg_key="epoupon.gpg.key"
ARG sources_list="epoupon.list"
ARG uid="1000"
ARG gid="1000"

ENV PUSER="fileshelter"
ENV APP_DIR="/var/fileshelter"

COPY docker-entrypoint.sh /usr/local/bin/

# Install libraries / dependencies
RUN apt-get -q update \
  && apt-get -y upgrade \
  && apt-get -q -y install --no-install-recommends \
  ca-certificates \
  gnupg2 \
  gosu \
  wget \
  && wget -q -O - "${catalog_url}/${gpg_key}" | apt-key add - \
  && echo "deb ${catalog_url} buster main" > /etc/apt/sources.list.d/"${sources_list}" \
  && apt-get update \
  && apt-get -q -y install fileshelter \
  && apt-get -q -y purge wget gnupg2 ca-certificates \
  && apt-get -q -y autoremove \
  && rm -rf /var/lib/apt/lists/* \
  # Change container user and group id to avoid permissions issues
  && usermod -u "$uid" "$PUSER" \
  && groupmod -g "$gid" "$PUSER" \
  && ln -s /usr/local/bin/docker-entrypoint.sh / \
  # Forward logs to Docker
  && ln -sf /dev/stdout "${APP_DIR}/fileshelter.log"

# Run application
VOLUME "$APP_DIR"
EXPOSE 5091
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["fileshelter"]