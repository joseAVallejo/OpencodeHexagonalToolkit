# Extensiones Locales

El toolkit proporciona una base común. Cada proyecto puede añadir sus propias
skills, agents y commands sin modificar el repositorio central.

## Crear una extensión

Usa el comando:

```text
/extension skill nombre-de-la-skill
/extension agent nombre-del-agent
/extension command nombre-del-command
```

Si no indicas el tipo o el nombre, el agente debe pedir la información antes
de crear archivos.

## Ubicaciones

```text
.opencode/
├── agents/
│   └── <nombre>.md
├── commands/
│   └── <nombre>.md
└── skills/
    └── <nombre>/
        └── SKILL.md
```

Las plantillas reutilizables están en `templates/`. No se cargan como
extensiones porque están fuera de los directorios que OpenCode escanea.

## Tipos

### Skill

Una skill aporta conocimiento o reglas que se activan por contexto. Su
frontmatter requiere `name` y `description`; el nombre debe coincidir con la
carpeta.

### Agent

Un agent define un rol autónomo. Declara `mode`, responsabilidad y permisos
mínimos. Usa `permission: deny` para herramientas que no necesite.

### Command

Un command es una acción explícita invocable como `/nombre`. Declara una
`description`, un `agent` y un cuerpo con instrucciones accionables. Usa
`$ARGUMENTS` para recibir la petición del usuario.

## Reglas de evolución

- Las extensiones nuevas pertenecen al proyecto activo.
- No sobrescribas una extensión existente al crear otra.
- Conserva nombres específicos del proyecto cuando la extensión dependa de su dominio.
- Valida frontmatter, permisos, seguridad y pruebas antes de usarla en equipo.
- Las actualizaciones del toolkit no eliminan archivos locales adicionales.
- Una extensión solo se incorpora manualmente al toolkit central si resulta reutilizable en varios proyectos.

## Licencia

El toolkit base se distribuye bajo la licencia indicada en `LICENSE`. Las
extensiones creadas para un proyecto deben seguir las reglas de licencia y
contribución de ese proyecto.
