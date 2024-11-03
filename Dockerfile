# https://github.com/doctor-server/steamcmd
FROM doctorserver/steamcmd:latest AS builder

# Set environment variables
ENV APP_ID=232250

# Create the update script
RUN cat <<EOF > ${HOME}/update_tf2_ds.txt
@ShutdownOnFailedCommand 1
@NoPromptForPassword 1
force_install_dir ${HOME}/serverfiles
login anonymous
app_update ${APP_ID} validate
quit
EOF

# Run the SteamCMD script
RUN steamcmd +runscript ${HOME}/update_tf2_ds.txt

# Set the remote build ID as an argument and validate it using the script
ARG REMOTE_BUILDID
COPY validate_buildid.sh ${HOME}/validate_buildid.sh
RUN chmod +x ${HOME}/validate_buildid.sh && ${HOME}/validate_buildid.sh ${APP_ID} ${REMOTE_BUILDID}

# Remove all map files if the 'slim' tag is specified
ARG TAG
RUN if [ "${TAG}" = "slim" ]; then rm -rf ${HOME}/serverfiles/tf/maps/*; fi

# https://github.com/doctor-server/steamcmd
FROM doctorserver/steamcmd:latest

# Update package lists, install necessary 32-bit libraries, and clean up to reduce image size
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y --no-install-recommends \
    lib32z1 \
    libncurses5:i386 \
    libbz2-1.0:i386 \
    lib32gcc-s1 \
    lib32stdc++6 \
    libtinfo5:i386 \
    libcurl3-gnutls:i386 \
    libsdl2-2.0-0:i386 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy only the necessary files from the builder stage to the final image
COPY --from=builder --chown=${USER}:${USER} ${HOME}/serverfiles ${HOME}/serverfiles

# Create a symbolic link to the TF2 server files for easier volume mounting
RUN ln -s ${HOME}/serverfiles/tf /tf

# Switch to the steam user for security reasons
USER ${USER}

# Set the working directory to the server files directory
WORKDIR ${HOME}/serverfiles
