#!/bin/bash
echo "Starting Project Zomboid server..."

cd /home/steam/Zomboid/server

# Set Java memory options
if [ "${DEBUG_ENABLED}" = "true" ]; then
    export _JAVA_OPTIONS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005 -Xmx${JAVA_MEMORY}"
else
    export _JAVA_OPTIONS="-Xmx${JAVA_MEMORY}"
fi

# Prepare additional startup flags
ADDITIONAL_FLAGS=""
if [ "${NOSTEAM}" = "true" ]; then
    ADDITIONAL_FLAGS="-nosteam"
    echo "Running in NO-STEAM mode. Steam Workshop features are disabled."
    echo "Ensure all mods are manually placed in /home/steam/Zomboid/mods/"
fi

echo "Using Java options: ${_JAVA_OPTIONS}"
echo "Beta branch: ${STEAM_BETA_BRANCH:-stable}"
echo "Additional flags: ${ADDITIONAL_FLAGS}"

# Run the official start script with optional flags
exec ./start-server.sh \
    -adminpassword "${ADMIN_PASSWORD}" \
    ${ADDITIONAL_FLAGS}
