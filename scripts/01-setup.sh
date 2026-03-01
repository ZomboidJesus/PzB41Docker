#!/bin/bash
set -e  # Exit on error

echo "=== Zomboid Server Startup ==="
echo "Debug Mode: ${DEBUG_ENABLED:-false}"
echo "Steps to debug: ${DEBUG_STEP:-none}"

# Function for breakpoints
breakpoint() {
    local step_name=$1
    if [[ ",${DEBUG_STEP}," == *",${step_name},"* ]]; then
        echo "⏸️  DEBUG BREAKPOINT at step: ${step_name}"
        echo "Press Enter to continue, or type 'shell' for a shell..."
        read -r input
        if [ "$input" = "shell" ]; then
            echo "Starting debug shell..."
            /bin/bash
        fi
    fi
}

# Step 1: Install/update server
breakpoint "install"
/scripts/02-install-server.sh

breakpoint "mods"
/scripts/05-install-mods.sh

# Step 2: Configure server
breakpoint "config"
/scripts/03-configure.sh

# Optional pause before starting
if [ "${PAUSE_BEFORE_START}" = "true" ]; then
    echo "⏸️  PAUSE_BEFORE_START enabled"
    echo "Server configured. Attach to container and check /home/steam/Zomboid"
    echo "Press Enter to start server..."
    read -r
fi

# Step 3: Start server
breakpoint "start"
/scripts/04-start-server.sh

