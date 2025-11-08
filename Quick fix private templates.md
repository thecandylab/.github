# 🔐 Solución Rápida: Plantillas en Repositorio Privado

## El Problema
Tu repositorio `.github` es privado y las plantillas no aparecen en otros repos de la organización.

## Causa más probable
La estructura de carpetas no es la correcta. GitHub es **MUY específico** sobre esto.
****
## ✅ Solución paso a paso

### 1. Verifica la estructura EXACTA
```bash
cd thecandylab/.github
ls -la
```

Debes ver:
```
.
├── .github/                    ← CARPETA llamada .github
│   └── ISSUE_TEMPLATE/         ← CARPETA con las plantillas
│       ├── bug-report.yml
│       ├── feature-request.yml
│       └── ...
├── README.md
└── otros archivos...
```

### 2. Si NO tienes la carpeta `.github` DENTRO del repo:
```bash
# Crear la estructura correcta
mkdir -p .github/ISSUE_TEMPLATE

# Mover las plantillas
mv *.yml .github/ISSUE_TEMPLATE/
# o si están en otra carpeta:
mv ISSUE_TEMPLATE/* .github/ISSUE_TEMPLATE/

# Confirmar estructura
tree .github/

# Commit y push
git add .
git commit -m "Fix: mover plantillas a .github/ISSUE_TEMPLATE"
git push
```

### 3. Verificar que NO haya plantillas locales interfiriendo
```bash
# En el repo donde quieres usar las plantillas
cd ../at-candy-postgres
ls -la .github/ISSUE_TEMPLATE/

# Si existe esta carpeta, las plantillas locales tienen PRIORIDAD
# Para usar las globales, elimina las locales:
rm -rf .github/ISSUE_TEMPLATE
git add .
git commit -m "Remove local templates to use organization templates"
git push
```

### 4. Esperar y refrescar
- Espera 2-3 minutos
- Cierra todas las pestañas de GitHub
- Abre en modo incógnito
- Ve a: https://github.com/thecandylab/at-candy-postgres/issues/new/choose

## 🧪 Verificación rápida

Si tienes un token de GitHub:
```bash
# Verificar que la estructura es correcta
curl -H "Authorization: token TU_TOKEN" \
  https://api.github.com/repos/thecandylab/.github/contents/.github/ISSUE_TEMPLATE
```

Deberías ver tus archivos .yml listados.

## ⚠️ Importante para repos privados

1. **Solo funciona para miembros de la organización** con acceso al repo `.github`
2. **La estructura DEBE ser**: `repo/.github/.github/ISSUE_TEMPLATE/`
3. **NO funciona** si el repo destino tiene sus propias plantillas locales

## 🚨 Si aún no funciona

Es casi seguro uno de estos:
- ❌ Estructura incorrecta (99% de los casos)
- ❌ Plantillas locales en el repo destino
- ❌ Caché del navegador

## 💡 Tip final
Si definitivamente la estructura está bien y no funciona, prueba hacer el repo `.github` público temporalmente solo para verificar que las plantillas funcionen, luego vuelve a hacerlo privado.
