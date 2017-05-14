# FileShelter Docker

A [Docker][1] workflow for running [FileShelter][2]. This includes two Docker images:

-   A minimal [FileShelter image][3] based on [Debian Scratch Slim][4]
-   A minimal [Caddy][5] image based on [Abiosoft's Alpine implementation][6] to act as a web proxy with automatic TLS termination. This image includes the [http.ratelimit][7] plugin.

[1]: https://docker.com
[2]: https://github.com/epoupon/fileshelter
[3]: https://hub.docker.com/r/paulgalow/fileshelter/
[4]: https://hub.docker.com/_/debian/
[5]: https://hub.docker.com/r/paulgalow/caddy/
[6]: https://github.com/abiosoft/caddy-docker
[7]: https://caddyserver.com/docs/http.ratelimit

## How to install

Clone or download this repository to your local machine or public facing server
```
git clone https://github.com/paulgalow/fileshelter-docker.git fileshelter
```

Make sure you have [Docker Engine][8] and [Docker Compose][9] installed on your machine.

If you're on a Mac all you need to do is installing [Docker for Mac][10].

[8]: https://docs.docker.com/engine/installation/
[9]: https://github.com/docker/compose/releases
[10]: https://docs.docker.com/docker-for-mac/install/

## Running FileShelter using Docker Compose

### Local development / testing
To stand up a development environment (e.g. locally on your machine) run:
```
docker-compose up
```
To connect to FileShelter, just open your favorite browser and go to `http://localhost/`

### Public facing / production
To stand up a production environment on a public facing server first edit the production Caddyfile at `webproxy/Caddyfile_production` and enter your public domain name and your e-mail address for registering your TLS certificates. Make sure that your host is available publicly on ports 80 and 443 and via the domain name specified in `webproxy/Caddyfile_production`.

Then run:
```
docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
```

Certificates are saved at `webproxy/certificates` to prevent hitting the Let's Encrypt rate limit.

Note: Docker Compose does not monitor the state of your containers once they have started. For real world production usage you might want to consider using [Docker Swarm][11] (or something similar) instead.

[11]: https://docs.docker.com/engine/swarm/

### Stopping the service

To stop services run:
```
docker-compose stop
```

To stop services, remove containers and networks run:
```
docker-compose down
```

## Customizing configuration

Make adjustments to the FileShelter configuration file (fileshelter.conf) located at `application/fileshelter.conf`

## Customizing layout and messages

Place your custom FileShelter application files (e.g. messages.xml) in `application/approot/`. Custom layout files such as `fileshelter.css` or `favicon.ico` should be placed in `application/docroot/` on your host.

## Persisting uploads

An easy way to persisting uploads and the FileShelter database on a single host is to [mount a host directory as a data volume][12] which is set up in the Docker Compose production environment.

[12]: https://docs.docker.com/compose/compose-file/#volumes

## Monitoring / Debugging

Monitor logs continuously with Docker Compose:
```
docker-compose logs -f
```

To enter and inspect the running Caddy container run:
```
docker exec -it caddy ash
```

To enter and inspect the running FileShelter container run:
```
docker exec -it fileshelter bash
```

## Security

The development setup serves files via HTTP only. The production setup automatically sets up TLS (including free certificates) using Caddy's [integration with Let's Encrypt][13].

This workflow comes with two Docker Compose and two Caddy setups, one for development and one for a production like scenario. Both containers communicate with each other on a private Docker network with only the web proxy (Caddy) exposing ports 80 and 443 to the Internet. To improve security both containers run on a read only filesystem (except the FileShelter persistence layer) with [dropped Linux capabilities][14]. The FileShelter container runs as an unprivileged user.

[13]: https://caddyserver.com/docs/automatic-https
[14]: http://rhelblog.redhat.com/2016/10/17/secure-your-containers-with-this-one-weird-trick/
