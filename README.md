# tf2-dedicated-server

[![Publish Docker Image (GPR)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-gpr.yml/badge.svg?branch=main)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-gpr.yml)
[![Publish Docker Image (Hub)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-hub.yml/badge.svg)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-hub.yml)
![Docker Image Version](https://img.shields.io/docker/v/doctorserver/tf2-dedicated-server)
![Docker Stars](https://img.shields.io/docker/stars/doctorserver/tf2-dedicated-server)
![Docker Pulls](https://img.shields.io/docker/pulls/doctorserver/tf2-dedicated-server)

This repository uses Docker and SteamCMD to download and check for updates to the TF2 dedicated server.
If there's an update, it pushes the latest Docker image to the [Docker Hub](https://hub.docker.com/repository/docker/doctorserver/tf2-dedicated-server)
and [GitHub Docker registry](https://github.com/doctor-server/tf2-dedicated-server/pkgs/container/tf2-dedicated-server).

| Image Name                                 | Image Tag | Image Size  |
|--------------------------------------------|-----------|------------:|
| doctorserver/tf2-dedicated-server          | `latest`  | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/doctorserver/tf2-dedicated-server/latest) |
| doctorserver/tf2-dedicated-server          | `slim`    | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/doctorserver/tf2-dedicated-server/slim) |

> `slim` removes unnecessary files like maps, which helps reduce the image size.

## Installation

To install the TF2 dedicated server from the command line, use one of the following commands:

```sh
docker pull doctorserver/tf2-dedicated-server:latest
```

or, use `slim` tag for smaller image size and faster deployment. (Recommended)

```sh
docker pull doctorserver/tf2-dedicated-server:slim
```

## Initialization (tag: `latest`)

### Step 1: Copy Server Files

First, create a temporary container to copy the necessary server files to your local `tf` directory:

```
docker create --name tf2-temp-server doctorserver/tf2-dedicated-server:latest sleep infinity
docker cp tf2-temp-server:/home/steam/serverfiles/tf/cfg ./tf
docker cp tf2-temp-server:/home/steam/serverfiles/tf/maps ./tf
docker cp tf2-temp-server:/home/steam/serverfiles/tf/materials ./tf
docker rm tf2-temp-server
```

### Step 2: Docker Compose Configuration

To run the TF2 server using Docker Compose, add the following service configuration to your `docker-compose.yml` file:

```yml
services:
  tf2-demo-server:
    image: doctorserver/tf2-dedicated-server:latest
    command: ./srcds_run -console -game tf +sv_pure 1 +randommap +maxplayers 24
    ports:
      - "27015:27015/tcp"
      - "27015:27015/udp"
    volumes:
      - ./tf/cfg:/tf/cfg
      - ./tf/maps:/tf/maps
      - ./tf/materials:/tf/materials
    restart: always
    tty: true
    stdin_open: true
```

## Initialization (tag: `slim`)

### Step 1: Copy Server Files

First, create a temporary container to copy the necessary server files to your local `tf` directory:

```
docker create --name doctorserver/tf2-dedicated-server:slim sleep infinity
docker cp tf2-temp-server:/home/steam/serverfiles/tf/cfg ./tf
docker cp tf2-temp-server:/home/steam/serverfiles/tf/maps ./tf
docker cp tf2-temp-server:/home/steam/serverfiles/tf/materials ./tf
docker rm tf2-temp-server
```

### Step 2: Add Maps

Ensure you add at least one map to the `maps` folder in your local `tf` directory.

### Step 3: Docker Compose Configuration

To run the TF2 server using Docker Compose, add the following service configuration to your `docker-compose.yml` file:

```yml
services:
  tf2-demo-server:
    image: doctorserver/tf2-dedicated-server:slim
    command: ./srcds_run -console -game tf +sv_pure 1 +randommap +maxplayers 24
    ports:
      - "27015:27015/tcp"
      - "27015:27015/udp"
    volumes:
      - ./tf/cfg:/tf/cfg
      - ./tf/maps:/tf/maps
      - ./tf/materials:/tf/materials
    restart: always
    tty: true
    stdin_open: true
```

## Usage

### Start the Server
To start the TF2 dedicated server, run the following command:
```sh
docker compose up -d
```

### Attach to the Server
To attach to the running container, use:
```sh
docker attach <container_name>
```

### Detach from the Server
To detach from the container without stopping it, use the key combination:
```
Ctrl + P, Ctrl + Q
```

## Development

> This section is for github developer

### Get Remote Build ID

#### Build the Docker Image

```sh
docker build --no-cache -f Dockerfile.buildid -t remote-buildid:232250 --build-arg APP_ID=232250 .
```

#### Retrieve the Remote Build ID

Run the following command to get the build ID from the Docker container:

```sh
docker run --rm remote-buildid:232250
```

> 16015580

### Building the Image

To build the Docker image locally, run the following command:

```sh
docker build -t tf2-dedicated-server:latest --build-arg REMOTE_BUILDID=<remote_buildid> --build-arg TAG=latest .
```

```sh
docker build -t tf2-dedicated-server:slim --build-arg REMOTE_BUILDID=<remote_buildid> --build-arg TAG=slim .
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
