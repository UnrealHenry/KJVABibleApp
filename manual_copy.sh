#!/bin/bash
echo "Finding simulator directory..."
SIMULATOR_DIR=$(find ~/Library/Developer/Xcode/UserData/Previews/Simulator\ Devices -name "KJVABibleApp.app" | head -1)
echo "Found app at: $SIMULATOR_DIR"
DEST_DIR="$SIMULATOR_DIR/Resources/Bible-kjv-1611-main"
mkdir -p "$DEST_DIR"
echo "Copying Bible resources..."
cp -R "KJVABibleApp/Resources/Bible-kjv-1611-main/"* "$DEST_DIR/"
echo "Bible files copied successfully!"
