#!/bin/bash

# Script to fix the "Multiple commands produce" error with Books.json

echo "Fixing Books.json conflict..."

# Find all Books.json files in the project
BOOKS_JSON_FILES=$(find . -name "Books.json")

echo "Found these Books.json files:"
echo "$BOOKS_JSON_FILES"

# Rename the KJV Books.json (if exists)
if [ -f "./KJVABibleApp/KJVABibleApp/Resources/Bible-kjv-1611-main/Books.json" ]; then
    echo "Renaming KJV Books.json to KJV-Books.json"
    mv "./KJVABibleApp/KJVABibleApp/Resources/Bible-kjv-1611-main/Books.json" "./KJVABibleApp/KJVABibleApp/Resources/Bible-kjv-1611-main/KJV-Books.json"
fi

# Rename the RV Books.json (if exists)
if [ -f "./KJVABibleApp/KJVABibleApp/Resources/Bible-rv-1602-main/Books.json" ]; then
    echo "Renaming RV Books.json to RV-Books.json"
    mv "./KJVABibleApp/KJVABibleApp/Resources/Bible-rv-1602-main/Books.json" "./KJVABibleApp/KJVABibleApp/Resources/Bible-rv-1602-main/RV-Books.json"
fi

echo "Now updating BibleDataManager.swift to use the renamed files..."

# Use sed to update the BibleDataManager.swift file to look for the renamed Books.json files
sed -i '' 's/Books.json/KJV-Books.json/g' "./KJVABibleApp/KJVABibleApp/Models/BibleData.swift"
sed -i '' 's/RV-Books.json/RV-Books.json/g' "./KJVABibleApp/KJVABibleApp/Models/BibleData.swift"

echo "Fix complete. Please rebuild your project."
echo "Note: You may need to manually update BibleDataManager.swift to use the renamed file paths."
