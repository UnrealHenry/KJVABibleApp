#!/bin/bash

echo "Fixing Xcode build phases for Bible files..."

# Set directories
APP_DIR="KJVABibleApp"
RESOURCES_DIR="${APP_DIR}/Resources"
KJV_DIR="${RESOURCES_DIR}/Bible-kjv-1611-main"
RV_DIR="${RESOURCES_DIR}/Bible-rv-1602-main"

# Create a Run Script build phase to copy Bible resources
cat > "${APP_DIR}/copy_bible_resources.sh" << 'EOF'
#!/bin/bash

# This script copies Bible resources to the app bundle
echo "Copying Bible resources to app bundle..."

# Set source and destination paths for KJV
KJV_SRC="${SRCROOT}/KJVABibleApp/Resources/Bible-kjv-1611-main"
KJV_DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-kjv-1611-main"

# Set source and destination paths for RV
RV_SRC="${SRCROOT}/KJVABibleApp/Resources/Bible-rv-1602-main"
RV_DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Resources/Bible-rv-1602-main"

# Create destination directories
mkdir -p "${KJV_DEST}"
mkdir -p "${RV_DEST}"

# Copy KJV resources
if [ -d "${KJV_SRC}" ]; then
    echo "Copying KJV Bible resources..."
    cp -R "${KJV_SRC}/"* "${KJV_DEST}/"
fi

# Copy RV resources
if [ -d "${RV_SRC}" ]; then
    echo "Copying RV Bible resources..."
    cp -R "${RV_SRC}/"* "${RV_DEST}/"
fi

# Verify Books.json files exist
if [ -f "${KJV_DEST}/KJV-Books.json" ]; then
    echo "Successfully copied KJV-Books.json"
else
    echo "ERROR: Failed to copy KJV-Books.json"
    exit 1
fi

if [ -f "${RV_DEST}/RV-Books.json" ]; then
    echo "Successfully copied RV-Books.json"
else
    echo "ERROR: Failed to copy RV-Books.json"
    exit 1
fi

echo "Bible resources copy completed successfully"
EOF

# Make the script executable
chmod +x "${APP_DIR}/copy_bible_resources.sh"

echo "Created copy_bible_resources.sh build phase script"
echo "Please add this script as a Run Script build phase in Xcode:"
echo "1. Open Xcode"
echo "2. Select the KJVABibleApp target"
echo "3. Go to Build Phases"
echo "4. Click + to add a new Run Script phase"
echo "5. Set the script to: ${SHELL} \"\${SRCROOT}/KJVABibleApp/copy_bible_resources.sh\""
echo ""
echo "This will ensure all Bible files are properly copied to the app bundle." 