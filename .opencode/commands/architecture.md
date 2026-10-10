---
description: Analiza dónde debe ubicarse una funcionalidad dentro de la arquitectura del proyecto.
agent: architect
---

Analiza la petición usando la skill `hexagonal-architecture` y devuelve:

1. Reglas de dominio y límites de consistencia.
2. Casos de uso y puertos de entrada.
3. Puertos de salida y capacidades externas.
4. Adaptadores de entrada y salida.
5. Dirección de dependencias y composition root.
6. Validación, errores, seguridad y transacciones.
7. Pruebas, riesgos y alternativas.

No implementes ni inventes requisitos. Trata CQRS y cualquier framework como
decisiones del repositorio activo.

Petición: $ARGUMENTS
