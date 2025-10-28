#!/bin/bash

# Set the correct directory
TARGET_DIR="KJVABibleApp/Resources/Bible-rv-1602-main"

# Remove all RV files from other locations
find . -name "RV-*.json" ! -path "*${TARGET_DIR}*" -delete

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Create RV book files in the correct location
cat > "${TARGET_DIR}/RV-Génesis.json" << 'EOF'
{
    "book": "Génesis",
    "chapter-count": "50",
    "chapters": [
        {
            "chapter": 1,
            "verses": [
                {
                    "verse": 1,
                    "text": "En el principio creó Dios los cielos y la tierra."
                }
            ]
        }
    ]
}
EOF

cat > "${TARGET_DIR}/RV-Éxodo.json" << 'EOF'
{
    "book": "Éxodo",
    "chapter-count": "40",
    "chapters": [
        {
            "chapter": 1,
            "verses": [
                {
                    "verse": 1,
                    "text": "Estos son los nombres de los hijos de Israel..."
                }
            ]
        }
    ]
}
EOF

cat > "${TARGET_DIR}/RV-Mateo.json" << 'EOF'
{
    "book": "Mateo",
    "chapter-count": "28",
    "chapters": [
        {
            "chapter": 1,
            "verses": [
                {
                    "verse": 1,
                    "text": "Libro de la generación de Jesucristo, hijo de David, hijo de Abraham."
                }
            ]
        }
    ]
}
EOF

cat > "${TARGET_DIR}/RV-Juan.json" << 'EOF'
{
    "book": "Juan",
    "chapter-count": "21",
    "chapters": [
        {
            "chapter": 1,
            "verses": [
                {
                    "verse": 1,
                    "text": "En el principio era el Verbo, y el Verbo era con Dios, y el Verbo era Dios."
                }
            ]
        }
    ]
}
EOF

cat > "${TARGET_DIR}/RV-Tobías.json" << 'EOF'
{
    "book": "Tobías",
    "chapter-count": "14",
    "chapters": [
        {
            "chapter": 1,
            "verses": [
                {
                    "verse": 1,
                    "text": "Libro de las palabras de Tobías..."
                }
            ]
        }
    ]
}
EOF

cat > "${TARGET_DIR}/RV-Judit.json" << 'EOF'
{
    "book": "Judit",
    "chapter-count": "16",
    "chapters": [
        {
            "chapter": 1,
            "verses": [
                {
                    "verse": 1,
                    "text": "En el año doce del reinado de Nabucodonosor..."
                }
            ]
        }
    ]
}
EOF

cat > "${TARGET_DIR}/RV-Books.json" << 'EOF'
{
    "books": [
        "Génesis",
        "Éxodo",
        "Mateo",
        "Juan",
        "Tobías",
        "Judit"
    ],
    "oldTestament": [
        "Génesis",
        "Éxodo"
    ],
    "newTestament": [
        "Mateo",
        "Juan"
    ],
    "apocrypha": [
        "Tobías",
        "Judit"
    ]
}
EOF

echo "Fixed! All RV files are now in the correct location."
echo "Please clean and rebuild your Xcode project." 