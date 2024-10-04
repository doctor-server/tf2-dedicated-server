# tf2-dedicated-server

[![Publish Docker Image (GPR)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-gpr.yml/badge.svg?branch=main)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-gpr.yml)

| Image Name                                 | Image Tag | Image Size  |
|--------------------------------------------|-----------|------------:|
| ghcr.io/doctor-server/tf2-dedicated-server | `latest`  |  12.53 GB   |
| ghcr.io/doctor-server/tf2-dedicated-server | `slim`    |   4.04 GB   |

> `slim` removes unnecessary files like maps, which helps reduce the image size.

## Installation

To install the TF2 dedicated server from the command line, use the following command:

```sh
docker pull ghcr.io/doctor-server/tf2-dedicated-server:latest
```

Copy the folder to the local tf directory

```
docker create --name tf2-temp-server ghcr.io/doctor-server/tf2-dedicated-server:latest sleep infinity
docker cp tf2-temp-server:/home/steam/serverfiles/tf/cfg ./tf
docker cp tf2-temp-server:/home/steam/serverfiles/tf/maps ./tf
docker cp tf2-temp-server:/home/steam/serverfiles/tf/materials ./tf
docker rm tf2-temp-server
```

To run the TF2 server using Docker Compose, add the following service configuration to your `docker-compose.yml` file:

```yml
services:
  tf2-demo-server:
    image: ghcr.io/doctor-server/tf2-dedicated-server:latest
    command: ./srcds_run -console -game tf +sv_pure 1 +randommap +maxplayers 24
    ports:
      - "27015:27015/tcp"
      - "27015:27015/udp"
    volumes:
      - ./tf/cfg:/tf/cfg
      - ./tf/maps:/tf/maps
      - ./tf/materials:/tf/materials
```

## Development

### Get Remote Build ID

#### Create a virtual environment

```sh
python -m venv venv
pip install -r requirements.txt
```

#### Get the remote build ID

```sh
python remote_buildid.py
```

> 15386092

### Building the Image

To build the Docker image locally, run the following command:

```sh
docker build -t tf2-dedicated-server:local --build-arg remote_buildid=<remote_buildid> .
```

### Running the Demo TF2 Server Locally

To run the demo TF2 server locally, use Docker Compose:

```sh
docker compose up -d
```

### Copy the folder to the local directory

To copy the server files to a local directory, use the following command:

```
docker cp tf2-demo-server:/home/steam/serverfiles/tf ./tf
```

> Successfully copied 11.7GB to C:\GitHub\tf2-dedicated-server\tf
