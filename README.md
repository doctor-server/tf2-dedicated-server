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
