---
name: sdd
description: Use when planning or implementing a new feature or significant functional change with Spec-Driven Development (SDD); coordinates planner, implementer, and reviewer through docs/specs/NNN_<feature>/specs.md, plan.md, and tasks.md with explicit approval gates.
---

# Spec-Driven Development (SDD)

Guía el trabajo de funcionalidades nuevas y cambios funcionales relevantes mediante especificaciones, planes y tareas trazables. La especificación es el ancla permanente del trabajo (**Spec-Anchored**) y debe mantenerse alineada con el comportamiento implementado y conservar el historial de cambios.

## Principios

1. Lee `docs/Constitution.md`, `AGENTS.md` y la documentación/código afectado antes de proponer una solución.
2. No inventes requisitos, reglas de negocio, contratos ni decisiones. Inspecciona el repositorio y pregunta al usuario cuando una ambigüedad afecte al alcance o al comportamiento.
3. Respeta las responsabilidades de los agentes descritas abajo. El coordinator habla con el usuario y orquesta; no delegues en agentes distintos de los definidos en su configuración.
4. No se implementa código hasta que el usuario apruebe la especificación y, en la puerta siguiente, el plan junto con las tareas.
5. La aprobación debe ser explícita e inequívoca. Si hay cambios solicitados, actualiza el documento correspondiente y vuelve a pedir aprobación de esa versión.
6. Crea los documentos por etapas y conserva los tres al completar la funcionalidad. Marca plan y tareas como completados; no los elimines.
7. Actualiza `specs.md` cuando cambien requisitos, alcance o criterios y añade una entrada cronológica a su historial.
8. Escribe documentación y respuestas en español, salvo que el usuario solicite otro idioma. Conserva sin traducir nombres de código, API y conceptos usados por el proyecto.

## Responsabilidades de los agentes

| Agente | Responsabilidad y límites |
|---|---|
| `coordinator` | Único interlocutor con el usuario. Coordina las etapas y aprobaciones, pasa contexto completo entre agentes, no edita archivos ni implementa. Si el cambio es pequeño y no requiere spec, sugiere `/feature`. |
| `planner` | Redacta/actualiza `specs.md`, `plan.md` y `tasks.md` dentro de `docs/specs/`; no escribe código. Si faltan datos para la spec, devuelve hasta cinco preguntas numeradas. |
| `reviewer` | Revisa la spec como QA y valida la implementación RF por RF. Solo lectura: detecta, informa veredictos y no modifica archivos ni propone soluciones durante la clarificación. |
| `implementer` | Implementa exactamente una tarea de un plan y tareas aprobados por llamada. Tests primero; ejecuta las pruebas, marca esa tarea solo si pasan y se detiene. No rediseña ni empieza la siguiente tarea. |

El coordinator debe transmitir en cada delegación la fase, la petición original, las decisiones del usuario, las rutas y documentos vigentes y el resultado de la fase previa: los subagentes no ven esta conversación.

## Rutas y numeración canónicas

```text
docs/
├── Constitution.md
└── specs/
    ├── 001_<feature>/
    │   ├── specs.md
    │   ├── plan.md
    │   └── tasks.md
    └── 002_<feature>/
        ├── specs.md
        ├── plan.md
        └── tasks.md
```

- Usa siempre `docs/specs/NNN_<feature>/specs.md` (plural `specs.md`) como nombre y ubicación canónicos de la especificación. No uses `spec.md`, `specs/` en la raíz ni rutas alternativas.
- Examina los directorios existentes directamente bajo `docs/specs/`; asigna el siguiente número libre de al menos tres dígitos, sin reutilizar ni renumerar números.
- El nombre es `<número>_<slug-descriptivo>`; usa minúsculas y guiones en el slug.
- Los cambios evolutivos de una funcionalidad actualizan su misma carpeta. Una funcionalidad distinta recibe un nuevo número.
- La ruta de Constitución es exactamente `docs/Constitution.md` (C mayúscula).
- Crea `docs/specs/` y el directorio de feature cuando sean necesarios.

## Flujo SDD y puertas de aprobación

### 0. Alcance y descubrimiento

El coordinator decide si el cambio requiere SDD. Para cambios pequeños sin spec, sugiere `/feature`. Para los demás:

1. Lee `docs/Constitution.md`, `AGENTS.md` y explora el código/documentación pertinente.
2. Pide al planner que prepare la especificación. Si el planner devuelve preguntas (máximo cinco), el coordinator las formula al usuario **de una en una** y reconsulta al planner con cada respuesta/contexto completo.
3. No conviertas hipótesis en requisitos. Registra en la spec los supuestos que el usuario haya confirmado.

### 1. Especificación: `specs.md`

El planner redacta solo el qué y el porqué; no incluye stack, arquitectura ni archivos a modificar. La spec se crea en el directorio asignado y comienza con estado **Borrador**. No crees todavía `plan.md` ni `tasks.md`.

Usa esta estructura, adaptando las secciones no pertinentes sin ocultar bloqueos:

```markdown
# Especificación: <funcionalidad>

> **ID:** NNN
> **Estado:** Borrador
> **Última actualización:** AAAA-MM-DD

## Resumen y problema
## Objetivos
## Fuera de alcance
## Usuarios y escenarios
## Requisitos funcionales
## Requisitos no funcionales y restricciones
## Criterios de aceptación
## Supuestos y decisiones confirmadas
## Preguntas abiertas / bloqueos
## Historial de cambios
| Fecha | Cambio | Motivo e impacto |
|---|---|---|
```

Escribe requisitos funcionales en formato **EARS**, con IDs estables (`RF-01`, etc.). Incluye casos límite y criterios de aceptación verificables (`CA-01`, etc.). No incluyas decisiones de implementación en la spec.

#### Clarificación y aprobación

1. El coordinator pide al reviewer una revisión QA **solo de detección**: ambigüedades, contradicciones, casos límite omitidos y conflictos con `docs/Constitution.md`. El reviewer no propone soluciones.
2. El coordinator enseña los hallazgos al usuario y pide al planner corregir la spec cuando corresponda. Resuelve los bloqueos mediante preguntas al usuario; no los resuelve por cuenta propia.
3. Presenta al usuario la spec revisada/diff y solicita aprobación explícita.
4. **Detente** hasta que el usuario apruebe `specs.md`. Ante cualquier cambio solicitado, el planner actualiza la spec y el coordinator vuelve a presentar la versión para aprobación.
5. Después de aprobar, el coordinator pide al planner registrar en la spec el estado **Aprobada**, la fecha y, si se revisa, la versión aprobada.

### 2. Plan y tareas: `plan.md` + `tasks.md`

Solo después de aprobar `specs.md`, el planner prepara ambos documentos a partir de esa spec aprobada. No escribe código. El plan debe contener:

- Enfoque, archivos/componentes afectados y propósito de cada cambio.
- Funciones/diseño propuestos, riesgos, dependencias y decisiones, incluida la alternativa descartada.
- Especificar funciones puras con `hoy` como parámetro.
- Estrategia de pruebas y correspondencia entre cada componente del plan y los RF/criterios cubiertos.

Las tareas deben ser como máximo diez, ordenadas, pequeñas y accionables. Cada tarea referencia los RF relevantes e incluye `Hecho cuando:` con una condición comprobable. Mantén también las tareas de validación necesarias.

Plantillas orientativas:

```markdown
# Plan: <funcionalidad>
> **ID:** NNN
> **Estado:** Borrador
> **Spec aprobada:** `specs.md` (<versión/fecha>)

## Enfoque técnico y diseño
## Archivos/componentes afectados
## Decisiones y alternativas descartadas
## Estrategia de tests
## Mapeo de RF a componentes y validaciones
## Riesgos/dependencias
```

```markdown
# Tareas: <funcionalidad>
> **ID:** NNN
> **Estado:** Pendiente
> **Plan:** `plan.md` (<versión/fecha>)

- [ ] T1 — <acción> (RF-01). **Hecho cuando:** <resultado verificable>.
```

El coordinator presenta el resumen de plan **y tareas** y solicita aprobación explícita conjunta antes de implementar. **Detente** hasta recibirla. No implementes si se ha aprobado la spec pero no el plan y las tareas. Tras la aprobación, el coordinator pide al planner registrar los estados aprobados y la fecha en ambos documentos; si el usuario pide cambios, el planner los realiza antes de volver a presentar ambos documentos.

Si un cambio del plan/tareas implica cambiar requisitos o criterios, actualiza y vuelve a aprobar primero `specs.md`; después regenera plan y tareas y solicita su aprobación.

### 3. Implementación, una tarea por llamada

1. El coordinator llama al implementer **una vez por tarea**, en el orden de `tasks.md`, transmitiendo rutas y el contexto de la tarea.
2. El implementer lee `tasks.md`, `plan.md`, `docs/Constitution.md` y `AGENTS.md`; implementa únicamente la tarea indicada, crea/actualiza primero los tests, confirma el fallo en rojo y después implementa.
3. El implementer ejecuta las pruebas pertinentes. Solo si pasan marca esa tarea como completada; luego se detiene y devuelve tarea/RF cubiertos, archivos, resultado de tests y decisiones no cubiertas por el plan.
4. El coordinator verifica el resultado comunicado tras cada tarea. Si los tests fallan, el implementer detecta que la tarea no es viable o hace falta rediseñar el plan, detiene el flujo e informa al usuario; no se continúa con la siguiente tarea ni se improvisa fuera del plan.
5. Si es la última tarea, el implementer devuelve un resumen final para que el coordinator registre cualquier conocimiento permanente en la documentación adecuada.

### 4. Validación, correcciones y cierre

1. Una vez completadas las tareas, el coordinator pide al reviewer validar la implementación contra la spec aprobada y revisar los cambios (`git diff`).
2. El reviewer lee `specs.md`, `plan.md`, `tasks.md` y los cambios, ejecuta las pruebas y recorre cada RF: indica qué test/verificación lo cubre y el resultado. Comprueba también los criterios de finalización y la Constitución.
3. El reviewer comienza exactamente con `VEREDICTO: APROBADO` o `VEREDICTO: CAMBIOS NECESARIOS`. Para cada cambio necesario indica archivo/línea, incumplimiento (tarea, RF o principio) y qué se espera. Las sugerencias no bloqueantes van aparte como `Opcional`.
4. Si hacen falta cambios, el coordinator entrega al implementer la lista exacta y solicita luego otra revisión. Se permiten como máximo **dos rondas** de corrección; si persiste el fallo, detén el flujo e informa al usuario de lo pendiente.
5. Solo si la revisión final aprueba y no quedan criterios obligatorios pendientes, el coordinator pide al planner marcar plan y tareas como **Completado** y registrar en el historial de la spec qué se implementó y validó. Conserva todos los documentos. El coordinator resume cambios, veredicto del reviewer y pendientes.

Si la validación no aprueba, no marques la feature completa. Documenta el estado real y los bloqueos.

## Cambios de requisitos en una funcionalidad existente

1. El planner actualiza primero `specs.md` en su carpeta canónica (nuevos RF en EARS, casos límite e historial); no modifica aún plan ni tareas.
2. El coordinator enseña el diff y espera aprobación de la spec revisada.
3. Solo tras esa aprobación, el planner actualiza `plan.md` y `tasks.md`; el coordinator presenta ambos y espera su aprobación conjunta.
4. Después continúa la implementación por tareas, revisión final y cierre descritos arriba.

## Comunicación

El coordinator informa en una línea al inicio de cada fase. Al final de cada etapa comunica el documento/ruta y el estado, y espera en las puertas indicadas. Nunca presenta el trabajo de un subagente como aprobado hasta recibir la aprobación del usuario o el veredicto correspondiente del reviewer.
