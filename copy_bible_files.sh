#!/bin/bash
# Script to copy Bible files to the app bundle

echo "Copying Bible files to the app bundle..."

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define source and destination directories
SOURCE_DIR="${SCRIPT_DIR}/KJVABibleApp/Resources/Bible-kjv-1611-main"
DEST_DIR="${SCRIPT_DIR}/KJVABibleApp/Resources"

# Check if source directory exists
if [ ! -d "${SOURCE_DIR}" ]; then
    echo "Source directory not found: ${SOURCE_DIR}"
    echo "Checking for alternative source locations..."
    
    # Try to find the Bible-kjv-1611-main directory
    FOUND_SOURCE=$(find "${SCRIPT_DIR}" -type d -name "Bible-kjv-1611-main" | head -n 1)
    
    if [ -n "${FOUND_SOURCE}" ]; then
        echo "Found alternative source: ${FOUND_SOURCE}"
        SOURCE_DIR="${FOUND_SOURCE}"
    else
        echo "Error: Could not find Bible-kjv-1611-main directory."
        exit 1
    fi
fi

# Create destination directory if it doesn't exist
mkdir -p "${DEST_DIR}"

# Copy the entire Bible-kjv-1611-main directory to the app bundle
cp -R "${SOURCE_DIR}" "${DEST_DIR}/"

echo "Bible files copied successfully to: ${DEST_DIR}/Bible-kjv-1611-main"
echo "Total files copied: $(find "${DEST_DIR}/Bible-kjv-1611-main" -name "*.json" | wc -l)"

# Ensure all files are included in the Xcode project (manual step needed)
echo "NOTE: Please make sure to add all JSON files to the Xcode project target if not already included."
echo "In Xcode: Right-click on the Resources folder > Add Files to 'KJVABibleApp' > Select all JSON files > Add"

echo "Script completed." 