# Repositorio de Plantillas de la Organización

Este repositorio contiene las plantillas de issues y configuraciones predeterminadas para todos los repositorios de nuestra organización.

## 📋 Plantillas de Issues Disponibles

- **Bug Report**: Para reportar errores o comportamientos inesperados
- **Feature Request**: Para solicitar nuevas funcionalidades
- **Epic**: Para definir conjuntos de funcionalidades relacionadas
- **User Story**: Para nuevas funcionalidades orientadas al usuario
- **Task**: Para tareas técnicas específicas
- **Tech Debt**: Para refactorización o mejoras técnicas

## 🏷️ Sistema de Etiquetas

### Por Área
- `area:frontend` - Cambios en Angular/UI
- `area:backend` - Cambios en Spring/API
- `area:db` - Cambios en base de datos
- `area:infrastructure` - Docker, servidores, redes
- `area:devops` - CI/CD, despliegues
- `area:dependencies` - Actualizaciones de librerías

### Por Prioridad
- `prio:P0` - Crítico (Bloquea producción)
- `prio:P1` - Alto (Funcionalidad importante)
- `prio:P2` - Medio (Mejora valorada)
- `prio:P3` - Bajo (Si sobra tiempo)

### Por Estado
- `status:blocked` - Bloqueado por dependencia externa
- `status:in-review` - Esperando revisión de código
- `status:testing` - En fase de testing/QA
- `status:wontfix` - No se va a resolver
- `status:duplicate` - Issue duplicado

### Por Tipo
- `type:feature` - Nuevas funcionalidades
- `type:bug` - Corrección de errores
- `type:chore` - Tareas de mantenimiento
- `type:security` - Parches de seguridad
- `type:refactor` - Refactorizaciones de código
- `type:docs` - Cambios en documentación
- `type:performance` - Mejoras de rendimiento

## 🚀 Aplicar Etiquetas a un Repositorio

Para aplicar estas etiquetas a un repositorio existente, ejecuta el script:

```bash
node scripts/apply-labels.js <OWNER> <REPO> <TOKEN>
```

Donde:
- `OWNER`: Nombre de la organización o usuario
- `REPO`: Nombre del repositorio
- `TOKEN`: Token de GitHub con permisos de escritura
