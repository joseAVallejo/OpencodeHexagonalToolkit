---
name: hexagonal-architecture
description: Aplica arquitectura hexagonal, Clean Architecture y CQRS al analizar o implementar funcionalidades.
---

# Arquitectura Hexagonal

Usa `AGENTS.md`, `docs/Constitution.md` y
`docs/architecture/hexagonal.md` como fuentes del proyecto. Antes de asumir
nombres de capas, frameworks o herramientas, inspecciona el repositorio activo.

## Reglas operativas

- Protege el núcleo formado por dominio y aplicación frente a detalles externos.
- Distingue dependencias estáticas del código y flujo de ejecución.
- Define cada puerto en la capa que necesita la capacidad.
- Mantén los puertos libres de tipos HTTP, ORM, proveedores y frameworks externos.
- Usa adaptadores para traducir modelos, protocolos, resultados y errores.
- Mantén los adaptadores de entrada finos y sin reglas centrales de negocio.
- Mantén I/O, serialización y detalles técnicos en adaptadores de salida.
- Organiza por funcionalidad cuando ayude a preservar límites claros.
- No expongas entidades de dominio como contratos externos.
- Coloca validación de transporte, aplicación, dominio e infraestructura en su frontera correspondiente.
- Localiza la composición de dependencias en el arranque o composition root.
- Prueba dominio y casos de uso sin infraestructura real; prueba adaptadores en sus fronteras.
- Trata CQRS, result types, mapeadores, ORM y contenedores DI como decisiones del proyecto.

## Durante un análisis

Identifica explícitamente:

1. Reglas de dominio y límites de consistencia.
2. Casos de uso y puertos de entrada.
3. Capacidades externas y puertos de salida.
4. Adaptadores de entrada y salida.
5. Dirección de dependencias y composition root.
6. Validación, errores, seguridad y transacciones.
7. Pruebas necesarias y riesgos de acoplamiento.

No crees interfaces por defecto. Toda abstracción debe proteger una frontera
real o facilitar una sustitución que el proyecto necesite.
