#!/bin/bash

# Script to set up the Reina-Valera 1602 Bible files
# This downloads the files and sets them up in the app resources directory

# Configuration
RV_DIR="Bible-rv-1602-main"
RESOURCES_DIR="KJVABibleApp/Resources"
APP_RESOURCES_DIR="KJVABibleApp/KJVABibleApp/Resources"
DOCUMENTS_DIR="$HOME/Library/Developer/CoreSimulator/Devices"
TEMP_DIR="/tmp/rv-bible-temp"

# Create directories if they don't exist
mkdir -p "$RESOURCES_DIR"
mkdir -p "$APP_RESOURCES_DIR"
mkdir -p "$TEMP_DIR"

echo "Setting up Reina-Valera 1602 Bible files..."

# Clone or download the repository
echo "Downloading Reina-Valera 1602 Bible files..."

# For this example, we'll create placeholder files
# In a real scenario, you would clone or download the actual Bible repository

# Create the Bible directory structure
mkdir -p "$RESOURCES_DIR/$RV_DIR"
mkdir -p "$APP_RESOURCES_DIR/$RV_DIR"

# Create a sample Books.json file with Spanish book names
cat > "$RESOURCES_DIR/$RV_DIR/Books.json" << EOF
{
  "books": [
    "Génesis", "Éxodo", "Levítico", "Números", "Deuteronomio", 
    "Josué", "Jueces", "Rut", "1 Samuel", "2 Samuel", 
    "1 Reyes", "2 Reyes", "1 Crónicas", "2 Crónicas",
    "Esdras", "Nehemías", "Ester", "Job", "Salmos", 
    "Proverbios", "Eclesiastés", "Cantar de los Cantares", "Isaías", 
    "Jeremías", "Lamentaciones", "Ezequiel", "Daniel", 
    "Oseas", "Joel", "Amós", "Abdías", "Jonás", 
    "Miqueas", "Nahum", "Habacuc", "Sofonías", 
    "Hageo", "Zacarías", "Malaquías",
    "Mateo", "Marcos", "Lucas", "Juan", "Hechos", 
    "Romanos", "1 Corintios", "2 Corintios", "Gálatas", 
    "Efesios", "Filipenses", "Colosenses", 
    "1 Tesalonicenses", "2 Tesalonicenses", "1 Timoteo", 
    "2 Timoteo", "Tito", "Filemón", "Hebreos", 
    "Santiago", "1 Pedro", "2 Pedro", "1 Juan", 
    "2 Juan", "3 Juan", "Judas", "Apocalipsis",
    "Tobías", "Judit", "Sabiduría", "Eclesiástico", "Baruc", 
    "Carta de Jeremías", "Oración de Azarías", "Susana", 
    "Bel y el Dragón", "Oración de Manasés", 
    "1 Macabeos", "2 Macabeos", "1 Esdras", "2 Esdras"
  ]
}
EOF

# Create sample book files
create_sample_book() {
    local book_name="$1"
    local chapter_count="$2"
    local verses_per_chapter="$3"
    
    cat > "$RESOURCES_DIR/$RV_DIR/$book_name.json" << EOF
{
  "book": "$book_name",
  "chapter-count": "$chapter_count",
  "chapters": [
EOF

    for chapter in $(seq 1 $chapter_count); do
        echo "    {" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
        echo "      \"chapter\": $chapter," >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
        echo "      \"verses\": [" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
        
        for verse in $(seq 1 $verses_per_chapter); do
            # Last verse doesn't need a comma
            if [ $verse -eq $verses_per_chapter ]; then
                echo "        {" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
                echo "          \"verse\": $verse," >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
                echo "          \"text\": \"Texto de $book_name $chapter:$verse en español. (Reina-Valera 1602)\"" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
                echo "        }" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
            else
                echo "        {" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
                echo "          \"verse\": $verse," >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
                echo "          \"text\": \"Texto de $book_name $chapter:$verse en español. (Reina-Valera 1602)\"" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
                echo "        }," >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
            fi
        done
        
        # Last chapter doesn't need a comma
        if [ $chapter -eq $chapter_count ]; then
            echo "      ]" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
            echo "    }" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
        else
            echo "      ]" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
            echo "    }," >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
        fi
    done
    
    echo "  ]" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
    echo "}" >> "$RESOURCES_DIR/$RV_DIR/$book_name.json"
}

# Create sample books (just a few for the example)
echo "Creating sample Bible book files..."
create_sample_book "Génesis" 3 5
create_sample_book "Éxodo" 3 5
create_sample_book "Mateo" 3 5
create_sample_book "Juan" 3 5
create_sample_book "Tobías" 3 5
create_sample_book "Judit" 3 5

# Copy to the app resources directory
echo "Copying files to app resources directory..."
cp -R "$RESOURCES_DIR/$RV_DIR/" "$APP_RESOURCES_DIR/"

# Copy to iOS simulator documents directory (if running in simulator)
echo "Note: To make the Bible files available in the simulator,"
echo "run the copy_reina_valera_to_sim.sh script after starting the simulator."

# Create the simulator copy script
cat > "copy_reina_valera_to_sim.sh" << EOF
#!/bin/bash

# Script to copy Reina-Valera Bible files to iOS simulator
SIMULATOR_DIR=\$(find $DOCUMENTS_DIR -name "data" -type d -depth 2 | sort -r | head -1)

if [ -z "\$SIMULATOR_DIR" ]; then
    echo "Error: Could not find simulator directory. Make sure a simulator is running."
    exit 1
fi

DOCUMENTS_DIR="\$SIMULATOR_DIR/Documents"
mkdir -p "\$DOCUMENTS_DIR/Bible-rv-1602-main"

echo "Copying Reina-Valera Bible files to simulator at \$DOCUMENTS_DIR..."
cp -R "$RESOURCES_DIR/$RV_DIR/"* "\$DOCUMENTS_DIR/Bible-rv-1602-main/"
echo "Done. Files copied to simulator."
EOF

chmod +x "copy_reina_valera_to_sim.sh"

# Create a fix script for the "Multiple commands produce" error
cat > "fix_books_json_conflict.sh" << EOF
#!/bin/bash

# Script to fix the "Multiple commands produce" error with Books.json

echo "Fixing Books.json conflict..."

# Find all Books.json files in the project
BOOKS_JSON_FILES=\$(find . -name "Books.json")

echo "Found these Books.json files:"
echo "\$BOOKS_JSON_FILES"

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
EOF

chmod +x "fix_books_json_conflict.sh"

echo "Setup complete!"
echo "Run ./copy_reina_valera_to_sim.sh after starting the simulator to copy the Bible files."
echo ""
echo "If you encounter a 'Multiple commands produce' error for Books.json,"
echo "run ./fix_books_json_conflict.sh to fix the issue." 