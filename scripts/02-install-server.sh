#!/bin/bash
echo "Installing/updating Project Zomboid server..."

cd /opt/steamcmd

# Determine the correct SteamCMD beta flag
BETA_FLAG=""
case "${STEAM_BETA_BRANCH}" in
    stable|"" )
        echo "Installing STABLE branch (Build 41)."
        # No -beta flag needed for stable
        ;;
    unstable|b42 )
        echo "Installing UNSTABLE/B42 branch."
        BETA_FLAG="-beta unstable"
        ;;
    * )
        echo "Warning: Unknown branch '${STEAM_BETA_BRANCH}'. Defaulting to unstable."
        BETA_FLAG="-beta unstable"
        ;;
esac

# Install to the correct directory
./steamcmd.sh +force_install_dir /home/steam/Zomboid/server \
    +login anonymous \
    +app_update 380870 ${BETA_FLAG} validate \
    +quit

echo "Server files ready at /home/steam/Zomboid/server"
