#!/bin/bash
echo "Configuring server..."

CONFIG_DIR="/home/steam/Zomboid/Server"
mkdir -p "${CONFIG_DIR}"

# Generate base config
cat > "${CONFIG_DIR}/servertest.ini" << EOF
[Server]
Name=${SERVER_NAME}
Description=${SERVER_DESCRIPTION:-Project Zomboid Server}
MaxPlayers=${MAX_PLAYERS:-8}
Port=${SERVER_PORT:-16261}
Public=${PUBLIC_SERVER:-false}
Open=true
Password=${SERVER_PASSWORD:-}

[Database]
SaveWorldEveryMinutes=15
EOF

FINAL_MOD_IDS=""
MOD_LIST_FILE="/home/steam/Zomboid/installed_mod_ids.txt"

if [ -n "${MOD_IDS}" ]; then
    FINAL_MOD_IDS="${MOD_IDS}"
elif [ -f "${MOD_LIST_FILE}" ]; then
    FINAL_MOD_IDS=$(paste -sd ";" "${MOD_LIST_FILE}")
fi

if [ -n "${FINAL_MOD_IDS}" ]; then
    CLEAN_MODS=$(echo "${FINAL_MOD_IDS}" | tr ',' ';')
    echo "Mods=${CLEAN_MODS}" >> "${CONFIG_DIR}/servertest.ini"
    echo "Loaded Mods."
fi

if [ -n "${WORKSHOP_IDS}" ]; then
    CLEAN_WORKSHOP=$(echo "${WORKSHOP_IDS}" | tr ',' ';')
    echo "WorkshopItems=${CLEAN_WORKSHOP}" >> "${CONFIG_DIR}/servertest.ini"
    echo "Loaded Workshop Items."
fi

if [ -n "${MAP_IDS}" ]; then
    CLEAN_MAPS=$(echo "${MAP_IDS}" | tr ',' ';')
    echo "Map=${CLEAN_MAPS}" >> "${CONFIG_DIR}/servertest.ini"
    echo "Loaded Maps."
fi

echo "${ADMIN_PASSWORD}" > "${CONFIG_DIR}/admin.txt"

echo "Configuration saved."
