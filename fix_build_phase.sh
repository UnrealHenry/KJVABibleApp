#!/bin/bash

echo "Fixing build phase for Bible files..."

# Set directories
APP_DIR="KJVABibleApp"
RESOURCES_DIR="${APP_DIR}/Resources"
RV_DIR="${RESOURCES_DIR}/Bible-rv-1602-main"

# Create the copy script that will be used in the build phase
cat > "${APP_DIR}/copy_bible_resources.sh" << 'EOF'
#!/bin/bash

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
EOF

# Make the script executable
chmod +x "${APP_DIR}/copy_bible_resources.sh"

echo "Created copy_bible_resources.sh"
echo ""
echo "Now in Xcode:"
echo "1. Remove any existing Copy Files or Copy Bundle Resources phases for RV-*.json files"
echo "2. Add a new Run Script phase with this content:"
echo "   ${SHELL} \"\${SRCROOT}/KJVABibleApp/copy_bible_resources.sh\""
echo "3. Move this Run Script phase to be the last phase in the build"
echo "4. Clean and rebuild the project" 