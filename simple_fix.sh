#!/bin/bash
# Simple script to modify the Books.json file to match the actual filenames

echo "Simple Bible Book Fix"
echo "===================="

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

# Get a list of actual JSON files in the directory
JSON_FILES=$(find "${BIBLE_DIR}" -name "*.json" -not -name "Books.json" -not -name "Books_chapter_count.json" | sort)
echo "Found $(echo "$JSON_FILES" | wc -l | tr -d ' ') Bible book JSON files"

# Create a new Books.json content with the actual filenames
echo "Creating new Books.json content..."

# Extract book names from filenames
BOOK_NAMES="["
for file in $JSON_FILES; do
    # Extract filename without path and extension
    filename=$(basename "$file" .json)
    BOOK_NAMES="$BOOK_NAMES\"$filename\", "
done
# Remove the trailing comma and space, add closing bracket
BOOK_NAMES="${BOOK_NAMES%, }]"

# Create a backup of the original Books.json
cp "${BOOKS_JSON_PATH}" "${BOOKS_JSON_PATH}.backup"
echo "Created backup at ${BOOKS_JSON_PATH}.backup"

# Write the new content to Books.json
echo "$BOOK_NAMES" > "${BOOKS_JSON_PATH}"
echo "Updated Books.json with actual available book files"

echo "Complete. Please rebuild your app." 