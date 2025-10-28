#!/bin/bash

# This script copies Bible files to the app bundle
echo "Copying Bible files to app bundle..."

# Create the destination directories
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-rv-1602-main"
mkdir -p "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-kjv-1611-main"

# Copy RV Bible files
cp -R "${SRCROOT}/KJVABibleApp/Resources/Bible-rv-1602-main/"* "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-rv-1602-main/"

# Copy KJV Bible files
cp -R "${SRCROOT}/KJVABibleApp/Resources/Bible-kjv-1611-main/"* "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-kjv-1611-main/"

echo "Bible files copied successfully" 