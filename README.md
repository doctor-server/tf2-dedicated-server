# tf2-dedicated-server

## Developement

### Building the Image

To build the Docker image locally, run the following command:

```sh
docker build -t tf2-dedicated-server:local .
```

### Getting the Local Build ID

To retrieve the local build ID of the game server, use the following command:

```
docker run --rm tf2-dedicated-server:local sh -c local_buildid.sh
```
