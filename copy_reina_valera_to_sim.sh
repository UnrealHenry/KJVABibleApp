#!/bin/bash

# Script to copy Reina-Valera Bible files to iOS simulator
SIMULATOR_DIR=$(find /Users/ahabyah/Library/Developer/CoreSimulator/Devices -name "data" -type d -depth 2 | sort -r | head -1)

if [ -z "$SIMULATOR_DIR" ]; then
    echo "Error: Could not find simulator directory. Make sure a simulator is running."
    exit 1
fi

DOCUMENTS_DIR="$SIMULATOR_DIR/Documents"
mkdir -p "$DOCUMENTS_DIR/Bible-rv-1602-main"

echo "Copying Reina-Valera Bible files to simulator at $DOCUMENTS_DIR..."
cp -R "KJVABibleApp/Resources/Bible-rv-1602-main/"* "$DOCUMENTS_DIR/Bible-rv-1602-main/"
echo "Done. Files copied to simulator."
