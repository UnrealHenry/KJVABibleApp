#!/bin/bash
# Script to debug and fix Bible file loading issues

echo "Bible Book Loading Diagnostic Tool"
echo "=================================="

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Find the Books.json file
BOOKS_JSON_PATH=$(find "${SCRIPT_DIR}" -name "Books.json" -type f | head -n 1)

if [ -z "${BOOKS_JSON_PATH}" ]; then
    echo "ERROR: Books.json not found in the project directory."
    exit 1
fi

echo "Found Books.json at: ${BOOKS_JSON_PATH}"
BIBLE_DIR=$(dirname "${BOOKS_JSON_PATH}")
echo "Bible directory: ${BIBLE_DIR}"

# Count JSON files in the Bible directory
JSON_COUNT=$(find "${BIBLE_DIR}" -name "*.json" | wc -l)
echo "Total JSON files in Bible directory: ${JSON_COUNT}"

# Read Books.json to get the list of books
BOOKS=$(cat "${BOOKS_JSON_PATH}" | tr -d '[]" ' | tr ',' '\n')
BOOK_COUNT=$(echo "${BOOKS}" | wc -l)
echo "Books.json contains ${BOOK_COUNT} books"

# Check which book JSON files are missing
echo "Checking for missing book files..."
MISSING_BOOKS=0

for book in ${BOOKS}; do
    # Remove any trailing commas
    book=$(echo "$book" | tr -d ',')
    
    # Skip empty lines
    if [ -z "$book" ]; then
        continue
    fi
    
    if [ ! -f "${BIBLE_DIR}/${book}.json" ]; then
        echo "Missing: ${book}.json"
        MISSING_BOOKS=$((MISSING_BOOKS + 1))
    fi
done

if [ ${MISSING_BOOKS} -eq 0 ]; then
    echo "All book files are present!"
else
    echo "${MISSING_BOOKS} book files are missing."
fi

# Ensure Bible directory is in the Resources folder
RESOURCES_DIR="${SCRIPT_DIR}/KJVABibleApp/Resources"
TARGET_BIBLE_DIR="${RESOURCES_DIR}/Bible-kjv-1611-main"

if [ "${BIBLE_DIR}" != "${TARGET_BIBLE_DIR}" ]; then
    echo "Bible directory is not in the expected location."
    echo "Current: ${BIBLE_DIR}"
    echo "Expected: ${TARGET_BIBLE_DIR}"
    
    echo "Copying Bible files to the correct location..."
    mkdir -p "${RESOURCES_DIR}"
    cp -R "${BIBLE_DIR}" "${TARGET_BIBLE_DIR}"
    echo "Files copied to ${TARGET_BIBLE_DIR}"
fi

echo ""
echo "Bible Book Files Status in Xcode Target"
echo "======================================"
echo "To ensure all Bible files are included in the app bundle, you need to add them to the Xcode project."
echo "Steps to add files in Xcode:"
echo "1. Open the project in Xcode"
echo "2. Right-click on Resources group in the Project Navigator"
echo "3. Select 'Add Files to \"KJVABibleApp\"...'"
echo "4. Navigate to ${TARGET_BIBLE_DIR}"
echo "5. Select all the JSON files"
echo "6. Make sure 'Copy items if needed' is UNCHECKED"
echo "7. Make sure 'Create groups' is selected"
echo "8. Make sure the KJVABibleApp target is checked"
echo "9. Click 'Add'"

echo ""
echo "Diagnostics complete. After adding the files to the Xcode project, rebuild the app." 