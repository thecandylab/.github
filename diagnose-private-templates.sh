#!/bin/bash

# Script de diagnóstico para plantillas en repos privados
# Uso: ./diagnose-private-templates.sh TOKEN

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Uso: $0 TU_GITHUB_TOKEN${NC}"
    echo -e "${YELLOW}Necesitas un token con permisos 'repo'${NC}"
    echo -e "${YELLOW}Crear en: https://github.com/settings/tokens${NC}"
    exit 1
fi

TOKEN=$1
ORG="thecandylab"

echo -e "${BLUE}=== Diagnóstico de Plantillas Privadas ===${NC}\n"

# 1. Verificar acceso al repo .github
echo -e "${YELLOW}1. Verificando acceso al repositorio .github...${NC}"
GITHUB_RESP=$(curl -s -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/${ORG}/.github")

if echo "$GITHUB_RESP" | grep -q '"private": true'; then
    echo -e "${GREEN}✓ Repositorio .github encontrado (privado)${NC}"
elif echo "$GITHUB_RESP" | grep -q '"private": false'; then
    echo -e "${YELLOW}⚠ El repositorio es público${NC}"
elif echo "$GITHUB_RESP" | grep -q "Not Found"; then
    echo -e "${RED}✗ No se encuentra el repositorio .github${NC}"
    exit 1
else
    echo -e "${RED}✗ Error al acceder al repositorio${NC}"
    echo "$GITHUB_RESP"
    exit 1
fi

# 2. Verificar estructura de carpetas
echo -e "\n${YELLOW}2. Verificando estructura .github/ISSUE_TEMPLATE...${NC}"
TEMPLATE_CHECK=$(curl -s -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/${ORG}/.github/contents/.github/ISSUE_TEMPLATE" \
    -w "\n%{http_code}")

HTTP_CODE=$(echo "$TEMPLATE_CHECK" | tail -n1)
CONTENT=$(echo "$TEMPLATE_CHECK" | head -n-1)

if [ "$HTTP_CODE" = "200" ]; then
    TEMPLATE_COUNT=$(echo "$CONTENT" | grep -c '"name"' || echo "0")
    echo -e "${GREEN}✓ Carpeta ISSUE_TEMPLATE encontrada con $TEMPLATE_COUNT plantillas${NC}"

    # Listar plantillas
    echo -e "\n${BLUE}Plantillas encontradas:${NC}"
    echo "$CONTENT" | grep '"name"' | cut -d'"' -f4 | while read -r template; do
        echo -e "  ${GREEN}✓${NC} $template"
    done
elif [ "$HTTP_CODE" = "404" ]; then
    echo -e "${RED}✗ No se encuentra la carpeta .github/ISSUE_TEMPLATE${NC}"
    echo -e "${YELLOW}  Verificando si existe la carpeta .github...${NC}"

    # Verificar carpeta .github
    GITHUB_FOLDER=$(curl -s -H "Authorization: token $TOKEN" \
        "https://api.github.com/repos/${ORG}/.github/contents/.github" \
        -w "\n%{http_code}" | tail -n1)

    if [ "$GITHUB_FOLDER" = "404" ]; then
        echo -e "${RED}  ✗ No existe la carpeta .github dentro del repositorio${NC}"
        echo -e "${YELLOW}  → Necesitas crear: ${ORG}/.github/.github/ISSUE_TEMPLATE/${NC}"
    else
        echo -e "${YELLOW}  ✓ La carpeta .github existe, pero falta ISSUE_TEMPLATE${NC}"
    fi
else
    echo -e "${RED}✗ Error al verificar plantillas (código: $HTTP_CODE)${NC}"
fi

# 3. Verificar permisos del usuario
echo -e "\n${YELLOW}3. Verificando tus permisos...${NC}"
USER_INFO=$(curl -s -H "Authorization: token $TOKEN" "https://api.github.com/user")
USERNAME=$(echo "$USER_INFO" | grep '"login"' | cut -d'"' -f4)
echo -e "  Usuario: ${BLUE}$USERNAME${NC}"

# Verificar membresía en la organización
ORG_MEMBERSHIP=$(curl -s -H "Authorization: token $TOKEN" \
    "https://api.github.com/user/memberships/orgs/${ORG}")

if echo "$ORG_MEMBERSHIP" | grep -q '"state": "active"'; then
    ROLE=$(echo "$ORG_MEMBERSHIP" | grep '"role"' | cut -d'"' -f4)
    echo -e "  ${GREEN}✓${NC} Miembro activo de ${ORG} (rol: $ROLE)"
else
    echo -e "  ${RED}✗${NC} No eres miembro activo de la organización"
fi

# 4. Probar en un repositorio específico
echo -e "\n${YELLOW}4. Probando en el repositorio at-candy-postgres...${NC}"
REPO_TEMPLATES=$(curl -s -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/${ORG}/at-candy-postgres/issues/templates")

if [ "$(echo "$REPO_TEMPLATES" | grep -c '"name"' || echo "0")" -gt 0 ]; then
    echo -e "${GREEN}✓ Se detectaron plantillas en el repositorio${NC}"
else
    echo -e "${RED}✗ No se detectaron plantillas${NC}"

    # Verificar si el repo tiene plantillas locales
    LOCAL_TEMPLATES=$(curl -s -H "Authorization: token $TOKEN" \
        "https://api.github.com/repos/${ORG}/at-candy-postgres/contents/.github/ISSUE_TEMPLATE" \
        -w "\n%{http_code}" | tail -n1)

    if [ "$LOCAL_TEMPLATES" = "200" ]; then
        echo -e "${YELLOW}  ⚠ El repositorio tiene plantillas locales que tienen prioridad${NC}"
    fi
fi

# 5. Resumen y recomendaciones
echo -e "\n${BLUE}=== Resumen ===${NC}"
echo -e "\n${YELLOW}Para que funcionen las plantillas globales en repos privados:${NC}"
echo -e "1. La estructura debe ser exacta: ${ORG}/.github/.github/ISSUE_TEMPLATE/"
echo -e "2. Debes ser miembro de la organización (✓ verificado)"
echo -e "3. El repositorio destino NO debe tener su propia carpeta .github/ISSUE_TEMPLATE/"
echo -e ""
echo -e "${BLUE}Próximos pasos:${NC}"

if [ "$HTTP_CODE" != "200" ]; then
    echo -e "${RED}1. Crear la estructura correcta:${NC}"
    echo -e "   cd ${ORG}/.github"
    echo -e "   mkdir -p .github/ISSUE_TEMPLATE"
    echo -e "   # Mover las plantillas a .github/ISSUE_TEMPLATE/"
    echo -e "   git add ."
    echo -e "   git commit -m 'Fix template structure'"
    echo -e "   git push"
else
    echo -e "${GREEN}1. La estructura parece correcta${NC}"
    echo -e "2. Intenta limpiar el caché:"
    echo -e "   - Cierra todas las pestañas de GitHub"
    echo -e "   - Abre en modo incógnito"
    echo -e "   - Ve a: https://github.com/${ORG}/at-candy-postgres/issues/new/choose"
fi
