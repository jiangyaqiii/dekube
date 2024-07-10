#!/bin/bash

# Define variables
DOWNLOAD_URL="https://s.dekube.ai/dekube+client/1.0.3/dekube"
FILE_NAME="dekube"
INSTALL_DIR="/usr/local/bin"
TARGET_DIR="$HOME/.dekube/.tool/taskmodule/"

# Obtain sudo privileges
if ! sudo -v; then
    echo "Failed to obtain sudo privileges."
    exit 1
fi

# Create and enter the directory
mkdir -p dekube-client
cd dekube-client || { echo "Failed to change directory to dekube-client"; exit 1; }

# Download the file
echo "Downloading $FILE_NAME from $DOWNLOAD_URL..."
if curl -O "$DOWNLOAD_URL"; then
    echo "Download successful!"

    # Create the start script
    echo "Extracting $FILE_NAME..."
    cat << EOF > start_dekube.sh
#!/bin/bash
nohup dekube start > output.log 2>&1 &
sleep 3
dekube log
echo "To stop DEKUBE, type 'dekube stop'"
echo "To check DEKUBE status, type 'dekube status'"
EOF

    # Change file permissions and move the executable file
    chmod +x "$FILE_NAME" start_dekube.sh
    sudo mv "$FILE_NAME" "$INSTALL_DIR/$FILE_NAME"
    echo "Finished!"

    # Environment check
    RED='\033[0;31m'
    NC='\033[0m' # No Color

    echo "Starting environment check..."

    # Function to check if a command exists
    command_exists() {
        command -v "$1" >/dev/null 2>&1
    }

    # Commands to check
    commands=("lspci" "lshw" "dmidecode" "nvidia-smi" "amd-smi")

    for cmd in "${commands[@]}"; do
        if ! command_exists "$cmd"; then
            echo -e "${RED}$cmd is not installed. Please install it manually.${NC}"
        fi
    done
    echo "If you do not have an NVIDIA or AMD graphics card, you can ignore the warnings about nvidia-smi or amd-smi."

    # Check if the directory exists
    if [ -d "$TARGET_DIR" ]; then
        # If the directory exists, remove it
        rm -rf "$TARGET_DIR"
    fi

    echo "Environment check completed."
    echo "To register DEKUBE, type \`dekube register [your_login_key]\`"
    echo "To start DEKUBE, type \`dekube start\`"
    echo "To stop DEKUBE, type \`dekube stop\`"
    echo "To check DEKUBE status, type \`dekube status\`"
else
    echo "Error: Download failed."
fi
