---
name: hexagonal-architecture
description: Aplica arquitectura hexagonal, Clean Architecture y CQRS al analizar o implementar funcionalidades.
---

# Hexagonal Architecture

Usa `AGENTS.md`, `docs/Constitution.md` y
`docs/architecture/hexagonal.md` como fuentes del proyecto. Respeta siempre
la dirección de dependencias hacia el dominio.

- Mantén el dominio aislado de infraestructura y delivery.
- Define puertos en la capa que posee la abstracción.
- Implementa adaptadores fuera del dominio y la aplicación.
- Organiza el código por funcionalidad.
- No expongas entidades de dominio como contratos externos.
- Trata CQRS, validación, result types y mapeadores como decisiones del proyecto, no como requisitos universales.

Inspecciona las convenciones existentes antes de crear nuevas abstracciones.
