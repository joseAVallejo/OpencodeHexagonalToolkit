---
description: Crea una skill, agent o command local para adaptar OpenCode al proyecto activo.
agent: build
---

Crea una extensión únicamente en el proyecto activo. No modifiques el
repositorio central del toolkit ni sobrescribas una extensión existente.

## Flujo

1. Determina el tipo: `skill`, `agent` o `command`.
2. Si falta el tipo o el nombre, pregunta antes de editar.
3. Lee `AGENTS.md`, `docs/Constitution.md` y `docs/extending.md`.
4. Revisa las plantillas en `templates/` y las convenciones existentes.
5. Genera el archivo en la ruta correcta:
   - Skill: `.opencode/skills/<nombre>/SKILL.md`
   - Agent: `.opencode/agents/<nombre>.md`
   - Command: `.opencode/commands/<nombre>.md`
6. Valida frontmatter, nombre, permisos mínimos y ausencia de secretos.
7. No reemplaces archivos existentes: propone otro nombre o detente.
8. Devuelve la ruta creada y un ejemplo de uso.

## Reglas

- Una skill debe explicar qué hace y cuándo se activa.
- Un agent debe definir responsabilidad, límites, modo y permisos.
- Un command debe tener descripción, agente y una plantilla accionable.
- La extensión debe ser específica del proyecto salvo que el usuario indique lo contrario.

Solicitud: $ARGUMENTS
