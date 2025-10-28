#!/bin/bash

echo "Fixing Bible file conflicts..."

# Set directories
APP_RESOURCES_DIR="KJVABibleApp/Resources"
KJV_DIR="${APP_RESOURCES_DIR}/Bible-kjv-1611-main"
RV_DIR="${APP_RESOURCES_DIR}/Bible-rv-1602-main"

# Ensure directories exist
mkdir -p "$KJV_DIR"
mkdir -p "$RV_DIR"

# Function to check and rename files
check_and_rename() {
    local dir=$1
    local prefix=$2
    
    echo "Checking files in $dir"
    
    # Find all JSON files that don't have the correct prefix
    for file in "$dir"/*.json; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            
            # Skip if already has correct prefix
            if [[ "$filename" == "$prefix"* ]]; then
                echo "  $filename already has correct prefix"
                continue
            fi
            
            # Skip Books files
            if [[ "$filename" == "Books.json" ]]; then
                echo "  Renaming Books.json to ${prefix}-Books.json"
                mv "$file" "${dir}/${prefix}-Books.json"
                continue
            fi
            
            # Create new filename with prefix
            new_filename="${prefix}-${filename}"
            echo "  Renaming $filename to $new_filename"
            mv "$file" "${dir}/${new_filename}"
        fi
    done
}

# Clean up any duplicate RV-Books.json files
echo "Cleaning up duplicate RV-Books.json files..."
find . -name "RV-Books.json" ! -path "*${RV_DIR}*" -delete

# Clean up any duplicate KJV-Books.json files
echo "Cleaning up duplicate KJV-Books.json files..."
find . -name "KJV-Books.json" ! -path "*${KJV_DIR}*" -delete

# Check and rename files in both directories
check_and_rename "$KJV_DIR" "KJV"
check_and_rename "$RV_DIR" "RV"

echo "Bible file conflicts fixed!"

# Verify the results
echo -e "\nVerifying results..."
echo "KJV directory contents:"
ls -la "$KJV_DIR"
echo -e "\nRV directory contents:"
ls -la "$RV_DIR" 