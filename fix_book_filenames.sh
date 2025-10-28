#!/bin/bash
# Script to fix Bible book filenames

echo "Bible Book Filename Fixer"
echo "========================="

# Get the directory containing the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BIBLE_DIR="$SCRIPT_DIR/KJVABibleApp/Resources/Bible-kjv-1611-main"

# Check if the Bible directory exists
if [ ! -d "$BIBLE_DIR" ]; then
    echo "Error: Bible directory not found at $BIBLE_DIR"
    exit 1
fi

# Create a mapping of book names to filenames
declare -A BOOK_TO_FILE
BOOK_TO_FILE["Song of Solomon"]="SongofSolomon"
BOOK_TO_FILE["Wisdom of Solomon"]="WisdomofSolomon"
BOOK_TO_FILE["Bel and the Dragon"]="BelandtheDragon"
BOOK_TO_FILE["Letter of Jeremiah"]="LetterofJeremiah"
BOOK_TO_FILE["Prayer of Azariah"]="PrayerofAzariah"
BOOK_TO_FILE["Prayer of Manasseh"]="PrayerofManasseh"

# Rename files
for book in "${!BOOK_TO_FILE[@]}"; do
    old_file="$BIBLE_DIR/$book.json"
    new_file="$BIBLE_DIR/${BOOK_TO_FILE[$book]}.json"
    
    if [ -f "$old_file" ]; then
        echo "Renaming $old_file to $new_file"
        mv "$old_file" "$new_file"
    fi
done

echo "File renaming complete!"

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

# Create a list of known filename substitutions
declare -A FILENAME_MAP
FILENAME_MAP["1 Samuel"]="1Samuel"
FILENAME_MAP["2 Samuel"]="2Samuel"
FILENAME_MAP["1 Kings"]="1Kings"
FILENAME_MAP["2 Kings"]="2Kings"
FILENAME_MAP["1 Chronicles"]="1Chronicles"
FILENAME_MAP["2 Chronicles"]="2Chronicles"
FILENAME_MAP["Song of Solomon"]="SongofSolomon"
FILENAME_MAP["1 Corinthians"]="1Corinthians"
FILENAME_MAP["2 Corinthians"]="2Corinthians"
FILENAME_MAP["1 Thessalonians"]="1Thessalonians"
FILENAME_MAP["2 Thessalonians"]="2Thessalonians"
FILENAME_MAP["1 Timothy"]="1Timothy"
FILENAME_MAP["2 Timothy"]="2Timothy"
FILENAME_MAP["1 Peter"]="1Peter"
FILENAME_MAP["2 Peter"]="2Peter"
FILENAME_MAP["1 John"]="1John"
FILENAME_MAP["2 John"]="2John"
FILENAME_MAP["3 John"]="3John"
FILENAME_MAP["1 Esdras"]="1Esdras"
FILENAME_MAP["2 Esdras"]="2Esdras"
FILENAME_MAP["Wisdom of Solomon"]="WisdomofSolomon"
FILENAME_MAP["Letter of Jeremiah"]="LetterofJeremiah"
FILENAME_MAP["Prayer of Azariah"]="PrayerofAzariah"
FILENAME_MAP["Bel and the Dragon"]="BelandtheDragon"
FILENAME_MAP["Prayer of Manasseh"]="PrayerofManasseh"
FILENAME_MAP["1 Maccabees"]="1Maccabees"
FILENAME_MAP["2 Maccabees"]="2Maccabees"

# Create a reverse lookup for existing files
declare -A REVERSE_MAP
for book in "${!FILENAME_MAP[@]}"; do
    REVERSE_MAP["${FILENAME_MAP[$book]}"]="$book"
done

# Read Books.json to get the list of books
echo "Parsing Books.json..."
BOOKS_JSON=$(cat "${BOOKS_JSON_PATH}")
BOOKS=$(echo "$BOOKS_JSON" | tr -d '[]' | tr ',' '\n' | sed 's/"//g' | sed 's/^ *//g')

# Fix the filenames
echo "Checking for book filename issues..."
FIXED_COUNT=0

# First, check if we need to create symlinks for files with spaces
for book in $BOOKS; do
    # Skip if the book file already exists
    if [ -f "${BIBLE_DIR}/${book}.json" ]; then
        continue
    fi
    
    # Check if there's a corresponding file without spaces
    bookNoSpaces=$(echo "$book" | tr ' ' '')
    if [ -f "${BIBLE_DIR}/${bookNoSpaces}.json" ]; then
        echo "Creating symlink: ${bookNoSpaces}.json -> ${book}.json"
        ln -sf "${BIBLE_DIR}/${bookNoSpaces}.json" "${BIBLE_DIR}/${book}.json"
        FIXED_COUNT=$((FIXED_COUNT + 1))
        continue
    fi
    
    # Check if this book has a known filename mapping
    if [ -n "${FILENAME_MAP[$book]}" ]; then
        if [ -f "${BIBLE_DIR}/${FILENAME_MAP[$book]}.json" ]; then
            echo "Creating symlink: ${FILENAME_MAP[$book]}.json -> ${book}.json"
            ln -sf "${BIBLE_DIR}/${FILENAME_MAP[$book]}.json" "${BIBLE_DIR}/${book}.json"
            FIXED_COUNT=$((FIXED_COUNT + 1))
            continue
        fi
    fi
    
    # General case: check for files that might match this book
    # Get the first part of the book name (e.g., "1" from "1 Kings")
    bookPrefix=$(echo "$book" | cut -d' ' -f1)
    
    # Check if it's a numbered book (like 1 Kings, 2 Samuel, etc.)
    if [[ "$bookPrefix" =~ ^[1-3]$ ]]; then
        bookSuffix=$(echo "$book" | cut -d' ' -f2-)
        potentialFile="${bookPrefix}${bookSuffix}.json"
        potentialFile=$(echo "$potentialFile" | tr ' ' '')
        
        if [ -f "${BIBLE_DIR}/${potentialFile}" ]; then
            echo "Creating symlink: ${potentialFile} -> ${book}.json"
            ln -sf "${BIBLE_DIR}/${potentialFile}" "${BIBLE_DIR}/${book}.json"
            FIXED_COUNT=$((FIXED_COUNT + 1))
            continue
        fi
    fi
    
    # Try removing spaces and other special characters
    bookClean=$(echo "$book" | tr ' ' '' | tr -d '.')
    if [ -f "${BIBLE_DIR}/${bookClean}.json" ]; then
        echo "Creating symlink: ${bookClean}.json -> ${book}.json"
        ln -sf "${BIBLE_DIR}/${bookClean}.json" "${BIBLE_DIR}/${book}.json"
        FIXED_COUNT=$((FIXED_COUNT + 1))
        continue
    fi
    
    echo "Could not find a matching file for: ${book}"
done

# Update the Books.json file if needed
echo ""
echo "Fixed ${FIXED_COUNT} book filename issues."

# Final diagnostic check
echo ""
echo "Running final diagnostic check..."
MISSING_BOOKS=0

for book in $BOOKS; do
    if [ ! -f "${BIBLE_DIR}/${book}.json" ]; then
        echo "Still missing: ${book}.json"
        MISSING_BOOKS=$((MISSING_BOOKS + 1))
    fi
done

if [ ${MISSING_BOOKS} -eq 0 ]; then
    echo "All book files are now accessible!"
else
    echo "${MISSING_BOOKS} book files are still missing."
fi

echo ""
echo "File fixing complete. Please rebuild your app." 