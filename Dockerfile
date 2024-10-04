# Use the SteamCMD base image for Ubuntu 22.04
FROM steamcmd/steamcmd:ubuntu-22 AS builder

# Set environment variables for the user and home directory
ENV USER=steam
ENV HOME=/home/${USER}

# Create a new user with a home directory and bash shell
RUN useradd --home-dir ${HOME} --create-home --shell /bin/bash ${USER}

# Copy the update script for the Team Fortress 2 dedicated server to the home directory
COPY update_tf2_ds.txt ${HOME}/update_tf2_ds.txt

# Run the SteamCMD script to update the TF2 server
RUN steamcmd +runscript ${HOME}/update_tf2_ds.txt

# Copy the build ID validation script to the home directory
COPY validate_buildid.sh ${HOME}/validate_buildid.sh

# Set the remote build ID as an argument and validate it using the script
ARG remote_buildid
RUN chmod +x ${HOME}/validate_buildid.sh && ${HOME}/validate_buildid.sh ${remote_buildid}

# Remove all map files if the 'slim' tag is specified
ARG tag
RUN if [ "${tag}" = "slim" ]; then rm -rf ${HOME}/serverfiles/tf/maps/*; fi


# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set environment variables for the user and home directory
ENV USER=steam
ENV HOME=/home/${USER}

# Update package lists, install necessary 32-bit libraries, and clean up to reduce image size
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y --no-install-recommends \
        lib32z1 \
        libncurses5:i386 \
        libbz2-1.0:i386 \
        lib32gcc-s1 \
        lib32stdc++6 \
        libtinfo5:i386 \
        libcurl3-gnutls:i386 \
        libsdl2-2.0-0:i386 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # Create a new user with a home directory and bash shell
    useradd --home-dir ${HOME} --create-home --shell /bin/bash ${USER}

# Copy only the necessary files from the builder stage to the final image
COPY --from=builder --chown=${USER}:${USER} ${HOME}/serverfiles ${HOME}/serverfiles

# Create a symbolic link to the TF2 server files for easier volume mounting
RUN ln -s ${HOME}/serverfiles/tf /tf

# Switch to the steam user for security reasons
USER ${USER}

# Set the working directory to the server files directory
WORKDIR ${HOME}/serverfiles

# Define an empty entrypoint to allow custom commands at runtime
ENTRYPOINT []
