---
name: testing
description: Define y ejecuta pruebas para cambios de comportamiento por capa y funcionalidad.
---

# Testing

Relaciona cada cambio con la prueba de la capa que posee el comportamiento:

- Dominio: reglas, entidades, value objects y eventos.
- Aplicación: casos de uso, handlers, validadores, resultados y DTOs.
- Infraestructura: repositorios e integraciones con dobles de prueba.
- Delivery: contratos, autorización, middleware y traducción de protocolos.

Ejecuta primero la prueba específica y después los comandos completos que
documente el repositorio activo. No presupongas .NET, xUnit ni una herramienta
concreta si el proyecto no la documenta.
