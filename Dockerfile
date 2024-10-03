# Use the SteamCMD base image for Ubuntu 22.04
FROM steamcmd/steamcmd:ubuntu-22

# Set environment variables for the user and home directory
ENV USER=steam
ENV HOME=/home/$USER

# Copy the local_buildid.sh script to the specified directory
COPY local_buildid.sh /usr/local/bin/local_buildid.sh

# Update package lists and install necessary 32-bit libraries
RUN apt update && \
    apt install -y --no-install-recommends \
        lib32z1 \
        libncurses5:i386 \
        libbz2-1.0:i386 \
        lib32gcc-s1 \
        lib32stdc++6 \
        libtinfo5:i386 \
        libcurl3-gnutls:i386 \
        libsdl2-2.0-0:i386 && \
    # Clean up to reduce image size
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # Create a new user with a home directory and bash shell
    useradd --home-dir $HOME --create-home --shell /bin/bash $USER && \
    # Make the script executable
    chmod +x /usr/local/bin/local_buildid.sh

# Set the working directory to the user's home directory
WORKDIR $HOME

# Copy the update script for Team Fortress 2 dedicated server
COPY update_tf2_ds.txt $HOME

# Run the SteamCMD script to update the TF2 server
RUN steamcmd +runscript $HOME/update_tf2_ds.txt

# Switch to the steam user
USER $USER

# Set the working directory to the server files directory
WORKDIR $HOME/serverfiles

# Define an empty entrypoint to allow custom commands at runtime
ENTRYPOINT []
