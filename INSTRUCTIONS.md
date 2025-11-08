# Instrucciones de Uso

## 🚀 Configuración Inicial

### 1. Crear el repositorio `.github` en tu organización

1. Ve a https://github.com/organizations/TU_ORGANIZACION/repositories/new
2. Nombra el repositorio exactamente como `.github`
3. Hazlo **público** para que las plantillas sean accesibles
4. Clona el repositorio y copia todos los archivos de esta carpeta

### 2. Personalizar las plantillas

Antes de usar las plantillas, personaliza los siguientes archivos:

#### `.github/ISSUE_TEMPLATE/config.yml`
Reemplaza:
- `YOUR_ORG` con el nombre de tu organización
- Los URLs de documentación y discusiones

#### `scripts/apply-labels.js`
El script está listo para usar, pero puedes modificar los colores o descripciones en `scripts/labels.json`

### 3. Generar un Token de GitHub

Para aplicar las etiquetas necesitas un token con permisos:

1. Ve a https://github.com/settings/tokens/new
2. Nombre: "Label Manager"
3. Permisos necesarios:
   - `repo` (acceso completo a repositorios)
4. Genera y copia el token

## 📋 Aplicar Etiquetas a un Repositorio

```bash
cd scripts
node apply-labels.js <ORGANIZACION> <REPOSITORIO> <TOKEN>
```

Ejemplo:
```bash
node apply-labels.js mi-empresa backend-api ghp_xxxxxxxxxxxx
```

## 🏷️ Sistema de Etiquetas

### Convención de Nombres

Las etiquetas siguen un sistema organizado por prefijos:

- **`area:`** - Área técnica del cambio
- **`prio:`** - Nivel de prioridad (P0-P3)
- **`status:`** - Estado del issue
- **`type:`** - Tipo de cambio
- **Sin prefijo** - Tipos de issues (Epic, User Story, etc.)

### Uso Recomendado

1. **Cada issue debe tener:**
   - Una etiqueta de tipo (type:* o Epic/User Story/Task/Tech Debt)
   - Una etiqueta de área (area:*)
   - Una etiqueta de prioridad (prio:*)

2. **Agregar según evolución:**
   - Etiquetas de estado cuando corresponda
   - Múltiples áreas si el cambio las afecta

## 🔄 Flujo de Trabajo Sugerido

### Para Bugs
1. Usuario crea issue con plantilla "Bug Report"
2. Automáticamente se aplica `type:bug`
3. Triaje agrega: área afectada + prioridad
4. Durante desarrollo: agregar `status:in-review`, `status:testing`

### Para Features
1. PM crea Epic con plantilla correspondiente
2. Desarrolladores crean User Stories vinculadas
3. Se descomponen en Tasks técnicas si es necesario
4. Tech Debt se documenta y prioriza por separado

## 🛠️ Mantenimiento

### Actualizar Etiquetas

1. Modifica `scripts/labels.json`
2. Ejecuta el script en cada repositorio
3. El script actualizará las etiquetas existentes

### Agregar Nuevas Plantillas

1. Crea el archivo en `.github/ISSUE_TEMPLATE/`
2. Sigue el formato YAML de las existentes
3. Actualiza la documentación

## ❓ Solución de Problemas

### Error de Autenticación
- Verifica que el token tenga permisos correctos
- Asegúrate de que no haya expirado

### Etiquetas no se Crean
- Verifica que tengas permisos de administrador en el repo
- Revisa que el nombre del repo sea correcto

### Plantillas no Aparecen
- El repositorio `.github` debe ser público
- Espera unos minutos para que GitHub actualice

## 📚 Referencias

- [Documentación de GitHub sobre plantillas](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests)
- [API de GitHub para etiquetas](https://docs.github.com/en/rest/issues/labels)
