#!/bin/bash

echo "Bible Books.json Fix Script"
echo "=========================="

# Get the directory containing the Bible books
BIBLE_DIR="/Users/ahabyah/Desktop/Program Projects/KJVABibleApp/KJVABibleApp/Resources/Bible-kjv-1611-main"

# Check if the directory exists
if [ ! -d "$BIBLE_DIR" ]; then
    echo "ERROR: Bible directory not found at: $BIBLE_DIR"
    exit 1
fi

# Books.json path
BOOKS_JSON="$BIBLE_DIR/Books.json"

if [ ! -f "$BOOKS_JSON" ]; then
    echo "ERROR: Books.json not found at: $BOOKS_JSON"
    exit 1
fi

echo "Found Books.json at: $BOOKS_JSON"

# Create a backup of the original file
cp "$BOOKS_JSON" "$BOOKS_JSON.backup.$(date +%s)"
echo "Created backup of Books.json"

# Get all JSON files except Books.json and Books_chapter_count.json
echo "Scanning for Bible book files..."
cd "$BIBLE_DIR"
BOOK_NAMES=()
for file in *.json; do
    # Skip Books.json and Books_chapter_count.json
    if [[ "$file" != "Books.json" && "$file" != "Books_chapter_count.json" ]]; then
        # Extract just the filename without the .json extension
        BOOK_NAME="${file%.json}"
        BOOK_NAMES+=("$BOOK_NAME")
        echo "Found book: $BOOK_NAME"
    fi
done

BOOK_COUNT=${#BOOK_NAMES[@]}
echo "Found $BOOK_COUNT Bible book files"

# Create a new Books.json array with proper formatting
echo "Creating properly formatted Books.json content..."
BOOKS_ARRAY="["
for (( i=0; i<${#BOOK_NAMES[@]}; i++ )); do
    # Add the book name to the array with proper JSON escaping
    BOOKS_ARRAY="$BOOKS_ARRAY\"${BOOK_NAMES[i]}\""
    # Add comma if not the last element
    if [ $i -lt $((${#BOOK_NAMES[@]}-1)) ]; then
        BOOKS_ARRAY="$BOOKS_ARRAY,"
    fi
done
BOOKS_ARRAY="$BOOKS_ARRAY]"

# Write the new content to Books.json
echo "$BOOKS_ARRAY" > "$BOOKS_JSON"
echo "Updated Books.json with proper book names"

# Verify the file
echo "Verifying Books.json content (first part):"
head -c 300 "$BOOKS_JSON"
echo "..."

echo "Fix complete. Please rebuild your app." 