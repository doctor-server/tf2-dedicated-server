# tf2-dedicated-server

[![Publish Docker Image (GPR)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-gpr.yml/badge.svg?branch=main)](https://github.com/doctor-server/tf2-dedicated-server/actions/workflows/docker-publish-gpr.yml)

### Installation

To install the TF2 dedicated server from the command line, use the following command:

```sh
docker pull ghcr.io/doctor-server/tf2-dedicated-server:latest
```

### Usage

To run the TF2 server using Docker Compose, add the following service configuration to your `docker-compose.yml` file:

```yml
services:
  tf2-server:
    image: ghcr.io/doctor-server/tf2-dedicated-server:latest
    command: ./srcds_run -console -game tf +sv_pure 1 +randommap +maxplayers 24
    ports:
      - "27015:27015/tcp"
      - "27015:27015/udp"
```

## Development

### Building the Image

To build the Docker image locally, run the following command:

```sh
docker build -t tf2-dedicated-server:local --build-arg remote_buildid=<your_build_id> .
```

### Running the Demo TF2 Server Locally

To run the demo TF2 server locally, use Docker Compose:

```sh
docker compose up -d
```
