#!/bin/bash

# Script para verificar la estructura correcta del repositorio .github
# Ejecutar desde dentro del repositorio .github clonado

echo "🔍 Verificando estructura del repositorio .github..."
echo "============================================"

# Verificar que estamos en el repo correcto
if [ ! -d ".git" ]; then
    echo "❌ ERROR: No estás en un repositorio git"
    echo "   Ejecuta este script desde dentro del repositorio .github clonado"
    exit 1
fi

# Verificar carpeta .github
if [ -d ".github" ]; then
    echo "✅ Carpeta .github encontrada"

    # Verificar subcarpeta ISSUE_TEMPLATE
    if [ -d ".github/ISSUE_TEMPLATE" ]; then
        echo "✅ Carpeta .github/ISSUE_TEMPLATE encontrada"

        # Contar plantillas
        TEMPLATES=$(find .github/ISSUE_TEMPLATE -name "*.yml" -o -name "*.yaml" | wc -l)
        echo "   📋 $TEMPLATES plantillas encontradas"

        # Verificar config.yml
        if [ -f ".github/ISSUE_TEMPLATE/config.yml" ]; then
            echo "✅ config.yml encontrado"
        else
            echo "❌ config.yml NO encontrado en .github/ISSUE_TEMPLATE/"
        fi
    else
        echo "❌ Carpeta .github/ISSUE_TEMPLATE NO encontrada"
        echo "   Créala con: mkdir -p .github/ISSUE_TEMPLATE"
    fi

    # Verificar carpeta security
    if [ -d ".github/security" ]; then
        echo "✅ Carpeta .github/security encontrada"
        if [ -f ".github/security/SECURITY.md" ]; then
            echo "✅ SECURITY.md encontrado"
        fi
    else
        echo "⚠️  Carpeta .github/security no encontrada (opcional)"
    fi
else
    echo "❌ ERROR: No existe la carpeta .github"
    echo "   Esta es la estructura correcta:"
    echo ""
    echo "   thecandylab/.github/     ← Repositorio"
    echo "   └── .github/             ← ESTA CARPETA FALTA"
    echo "       └── ISSUE_TEMPLATE/ ← Aquí van las plantillas"
    echo ""
    echo "   Créala con: mkdir -p .github/ISSUE_TEMPLATE"
fi

# Verificar scripts
if [ -d "scripts" ]; then
    echo "✅ Carpeta scripts encontrada"
    if [ -f "scripts/apply-labels.js" ]; then
        echo "✅ apply-labels.js encontrado"
    fi
    if [ -f "scripts/labels.json" ]; then
        echo "✅ labels.json encontrado"
    fi
fi

echo ""
echo "============================================"

# Mostrar estructura actual
echo "📁 Estructura actual:"
echo ""
tree -L 3 -a 2>/dev/null || find . -type d -not -path '*/\.*' | sed 's|./||' | sort

echo ""
echo "💡 Recuerda:"
echo "   - La carpeta .github DENTRO del repo .github es OBLIGATORIA"
echo "   - Las plantillas van en .github/ISSUE_TEMPLATE/"
echo "   - Después de cambios, espera 2-3 minutos para que GitHub los detecte"
