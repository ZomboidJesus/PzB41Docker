#!/bin/bash
set -e

echo "=== Mod Installation (Symlink Mode) ==="

if [ -z "${WORKSHOP_IDS}" ]; then
    echo "No WORKSHOP_IDS found. Skipping."
    exit 0
fi

IDS=$(echo "${WORKSHOP_IDS}" | tr "," " " | tr ";" " ")

DEST_DIR="/home/steam/Zomboid/mods"
MOD_LIST_FILE="/home/steam/Zomboid/installed_mod_ids.txt"

mkdir -p "${DEST_DIR}"
> "${MOD_LIST_FILE}"

STEAM_SCRIPT="/tmp/steamcmd_script.txt"
echo "login anonymous" > "${STEAM_SCRIPT}"
for ID in ${IDS}; do
    echo "workshop_download_item 108600 ${ID}" >> "${STEAM_SCRIPT}"
done
echo "quit" >> "${STEAM_SCRIPT}"

cd /opt/steamcmd
if ! timeout 900 ./steamcmd.sh +runscript "${STEAM_SCRIPT}"; then
    echo "Warning: SteamCMD verification reported issues. Check logs."
fi

for ID in ${IDS}; do
    SOURCE_DIR="/home/steam/Steam/steamapps/workshop/content/108600/${ID}"

    if [ ! -d "${SOURCE_DIR}" ]; then
        echo "Error: Mod ${ID} not found in cache."
        continue
    fi

    mapfile -t MOD_DIRS < <(
        find "${SOURCE_DIR}" -type f -name "mod.info" -printf '%h\n' | sort -u
    )

    if [ ${#MOD_DIRS[@]} -eq 0 ]; then
        echo "Warning: No mod.info found in ${ID}"
        continue
    fi

    for MOD_CONTENT_DIR in "${MOD_DIRS[@]}"; do
        MOD_NAME=$(basename "${MOD_CONTENT_DIR}")

        rm -rf "${DEST_DIR:?}/${MOD_NAME}"
        ln -s "${MOD_CONTENT_DIR}" "${DEST_DIR}/${MOD_NAME}"

        echo "${MOD_NAME}" >> "${MOD_LIST_FILE}"
        echo "Linked: ${MOD_NAME} (from ${ID})"
    done
done

awk '!seen[$0]++' "${MOD_LIST_FILE}" > "${MOD_LIST_FILE}.tmp" && mv "${MOD_LIST_FILE}.tmp" "${MOD_LIST_FILE}"

echo "=== Mod Installation Complete ==="
