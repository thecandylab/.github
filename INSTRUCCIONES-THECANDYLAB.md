# 🚀 Instrucciones para TheCandyLab

## Estructura correcta que DEBES crear:

```
thecandylab/.github/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug-report.yml
│   │   ├── config.yml
│   │   ├── epic.yml
│   │   ├── task.yml
│   │   ├── tech-debt.yml
│   │   └── user-story.yml
│   ├── PULL_REQUEST_TEMPLATE/
│   │   ├── PULL_REQUEST_TEMPLATE.md
│   │   ├── config.yml
│   │   └── feature-request.yml
│   ├── security/
│   │    └── SECURITY.md
│   └── workflows/
│       └── issue-automation.yml
├── scripts/
│   ├── apply-labels.js
│   └── labels.json
├── .gitignore
├── INSTRUCCIONES-THECANDYLAB.md
├── INSTRUCTIONS.md
├── Quick fix private templates.md
├── README.md
├── verificar-estructura.sh
└── diagnose-private-templates.sh
```

## 📝 Pasos exactos:

### 1. Clona tu repositorio .github
```bash
git clone https://github.com/thecandylab/.github.git
cd .github
```

### 2. Crea la estructura correcta
```bash
# ⚠️ IMPORTANTE: Crear carpeta .github DENTRO del repo
mkdir -p .github/ISSUE_TEMPLATE
mkdir -p .github/security
mkdir -p scripts
```

### 3. Copia los archivos a sus ubicaciones

**config.yml** → `.github/ISSUE_TEMPLATE/config.yml`
```yaml
# Configuración de las plantillas de issues
blank_issues_enabled: false
contact_links:
  - name: 💬 Discusiones
    url: https://github.com/orgs/thecandylab/discussions
    about: Para preguntas generales y discusiones
  - name: 📚 Documentación
    url: https://thecandylab.com
    about: Consulta nuestra documentación
  - name: 🛡️ Reporte de Seguridad
    url: https://github.com/thecandylab/.github/security/policy
    about: Para reportar vulnerabilidades de seguridad de forma privada
```

**Plantillas** → `.github/ISSUE_TEMPLATE/`
- Copia todos los archivos .yml de plantillas aquí

**SECURITY.md** → `.github/security/SECURITY.md`

**Scripts** → `scripts/`
- apply-labels.js
- labels.json

### 4. Commit y push
```bash
git add .
git commit -m "Add issue templates and organization configuration"
git push
```

### 5. Verifica que funcione
Espera 2-3 minutos, luego ve a:
```
https://github.com/thecandylab/at-candy-postgres/issues/new/choose
```

## ⚠️ Errores comunes a evitar:

1. **NO pongas** las plantillas en la raíz del repo
2. **NO olvides** la carpeta `.github` dentro del repo `.github`
3. **NO tengas** plantillas locales en los repos donde quieres usar las globales

## 🔍 Para verificar que está bien:

En tu repo `.github`, el comando `tree` debería mostrar:
```
.
├── .github/                    ← Esta carpeta es CRUCIAL
│   ├── ISSUE_TEMPLATE/
│   │   ├── config.yml
│   │   └── *.yml
│   └── security/
│       └── SECURITY.md
├── README.md
└── scripts/
    └── ...
```

## 💡 Si no funciona después de esto:

1. Verifica que no haya carpetas `.github/ISSUE_TEMPLATE/` en los repos individuales
2. Limpia el caché del navegador
3. Prueba en modo incógnito

¡Con esto debería funcionar perfectamente! 🎉
