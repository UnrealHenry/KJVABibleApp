#!/bin/bash

# This script copies Bible resources to the app bundle
echo "Copying Bible resources to app bundle..."

# Set paths
RV_SRC="${SRCROOT}/KJVABibleApp/Resources/Bible-rv-1602-main"
RV_DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-rv-1602-main"

# Create destination directory
mkdir -p "${RV_DEST}"

# Copy RV Bible files one by one to avoid conflicts
for file in "${RV_SRC}"/RV-*.json; do
    if [ -f "$file" ]; then
        base=$(basename "$file")
        cp "$file" "${RV_DEST}/${base}"
        echo "Copied ${base}"
    fi
done

echo "Bible resources copied successfully" 