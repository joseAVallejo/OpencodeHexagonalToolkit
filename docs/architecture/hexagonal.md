# Arquitectura Hexagonal

La arquitectura hexagonal, también conocida como Ports and Adapters, protege
las reglas de negocio y los casos de uso frente a detalles externos como
HTTP, bases de datos, mensajería o proveedores de terceros.

El hexágono es una representación conceptual. No exige seis capas, seis
módulos ni una estructura física concreta.

## Objetivos

- Aislar políticas de negocio de mecanismos técnicos.
- Reducir el acoplamiento entre negocio y tecnología.
- Hacer explícitos los límites y contratos.
- Permitir sustituir adaptadores sin reescribir el núcleo.
- Facilitar pruebas sin infraestructura real.

## Núcleo y límites

El núcleo suele estar formado por dos responsabilidades relacionadas:

- **Dominio:** conceptos, invariantes, entidades, value objects, agregados y reglas de negocio.
- **Aplicación:** casos de uso, coordinación, puertos y resultados de aplicación.

No toda aplicación necesita un dominio complejo. En sistemas pequeños puede
existir un dominio reducido y casos de uso directos, siempre que los límites
sean claros.

```text
Actores y sistemas externos
        |
Adaptadores de entrada
        |
Puertos de entrada
        |
Aplicación: casos de uso y coordinación
        |
Puertos de salida
        |
Adaptadores de salida
        |
Bases de datos, APIs, mensajería y otros sistemas

Dominio: reglas e invariantes utilizadas por la aplicación
```

## Dirección de dependencias

Las dependencias estáticas del código deben apuntar hacia las políticas
internas, aunque el flujo de ejecución pueda viajar hacia un adaptador.

```text
Adaptadores -> Puertos y aplicación -> Dominio
```

- El dominio no depende de aplicación, infraestructura, delivery ni frameworks.
- La aplicación depende del dominio y de los puertos que necesita.
- Los adaptadores dependen de los contratos internos que implementan.
- El punto de composición conecta implementaciones concretas con los puertos.

El flujo de ejecución y la dirección de dependencias no son lo mismo:

```text
Aplicación -> Puerto de salida <- Adaptador PostgreSQL -> Base de datos
```

La aplicación solicita una capacidad al puerto, pero su código fuente no
depende de PostgreSQL.

## Puertos

Un puerto es un contrato que expresa una capacidad sin revelar la tecnología
que la implementa. Puede ser una interfaz, una función pública, un protocolo
o cualquier forma equivalente del lenguaje y framework utilizados.

### Puertos de entrada

También llamados *driving* o *inbound*. Definen las operaciones que un actor
puede solicitar a la aplicación.

Ejemplos:

- `CreateOrderUseCase`
- `QueryAccount`
- `RegisterUser`

Responden a la pregunta: **¿qué puede pedirse a la aplicación?**

### Puertos de salida

También llamados *driven* u *outbound*. Definen capacidades externas que un
caso de uso necesita para realizar su trabajo.

Ejemplos:

- `OrderRepository`.
- `PaymentGateway`.
- `NotificationSender`.
- `EventPublisher`.
- `Clock`.

Responden a la pregunta: **¿qué necesita la aplicación del exterior?**

El puerto debe pertenecer a la capa que necesita la capacidad. Un puerto de
persistencia requerido por un caso de uso suele pertenecer a Application; un
puerto puramente ligado a una regla de dominio puede pertenecer a Domain.

### Características de un buen puerto

- Propósito claro y acotado.
- Contrato expresado en términos del dominio o la aplicación.
- Entradas, salidas y errores relevantes explícitos.
- Sin tipos de ORM, HTTP, proveedores o frameworks externos.
- Sin capacidades innecesarias para sus implementaciones.
- Abstracción motivada por una frontera real, no por crear interfaces por defecto.

## Adaptadores

Un adaptador traduce entre el exterior y un puerto. El puerto define la
capacidad; el adaptador conecta esa capacidad con un actor o mecanismo
concreto.

### Adaptadores de entrada

Reciben una interacción externa y llaman a un puerto de entrada.

Ejemplos:

- Controller o endpoint HTTP.
- CLI.
- Interfaz gráfica.
- Consumidor de mensajes.
- Tarea programada.
- Prueba automatizada.

Responsabilidades habituales:

- Interpretar el formato externo.
- Validar sintaxis y transporte.
- Convertir modelos externos a parámetros de aplicación.
- Invocar el caso de uso.
- Traducir el resultado a HTTP, JSON, texto, UI o mensaje.

Un adaptador de entrada debe ser fino. No debe contener reglas centrales del
negocio ni acceso directo a infraestructura.

### Adaptadores de salida

Implementan puertos de salida usando una tecnología externa.

Ejemplos:

- Repositorio SQL.
- Cliente de una API externa.
- Publicador de mensajes.
- Servicio SMTP.
- Implementación en memoria para pruebas.

Responsabilidades habituales:

- Traducir el modelo interno al formato externo.
- Ejecutar consultas, llamadas o publicaciones.
- Gestionar serialización y detalles del protocolo.
- Convertir errores externos en resultados manejables por la aplicación.

Los adaptadores no deben decidir reglas de negocio que pertenecen al núcleo.

## Dominio

El dominio debe poder entenderse y probarse sin conocer HTTP, ORM, SQL,
clientes concretos, variables de entorno o configuración de despliegue.

### Conceptos habituales

- **Entidad:** objeto con identidad y ciclo de vida.
- **Value object:** objeto definido por sus valores, normalmente inmutable.
- **Agregado:** límite de consistencia con una raíz que protege sus reglas.
- **Invariante:** condición que siempre debe cumplirse.
- **Servicio de dominio:** operación que no encaja naturalmente en una entidad o value object.

El dominio no debe importar controladores, requests, responses, tablas,
clientes HTTP ni clases de proveedores.

## Aplicación y casos de uso

Application define y coordina las acciones que el sistema ofrece a sus
actores.

Responsabilidades:

- Exponer casos de uso mediante puertos de entrada.
- Coordinar dominio y puertos de salida.
- Aplicar reglas propias del flujo de aplicación.
- Definir resultados y errores de aplicación.
- Coordinar límites transaccionales cuando corresponda.
- Solicitar persistencia, eventos o llamadas externas mediante contratos.

Application no debe:

- Contener códigos HTTP, cabeceras o detalles de transporte.
- Ejecutar SQL directamente.
- Depender de repositorios o clientes concretos.
- Repetir reglas de negocio que pertenecen al dominio.
- Convertirse en un contenedor de toda la lógica del sistema.

CQRS puede ser útil para separar lecturas y escrituras, pero no es un
requisito de la arquitectura hexagonal.

## Validación y errores

La ubicación depende de qué se valida:

- **Transporte:** JSON válido, tipos, campos obligatorios del protocolo; adaptador de entrada.
- **Aplicación:** precondiciones del caso de uso y coordinación; Application.
- **Dominio:** invariantes y estados válidos; Domain.
- **Infraestructura:** claves, tipos de columna, disponibilidad y restricciones técnicas; adaptador de salida.

Puede existir validación repetida por seguridad o integridad, pero las reglas
deben tener una fuente clara para evitar contradicciones.

Los errores también deben traducirse en cada frontera:

- El dominio expresa violaciones de reglas de negocio.
- Application expresa fallos del caso de uso.
- Un adaptador de salida traduce errores técnicos externos.
- Un adaptador de entrada traduce el resultado al protocolo y nunca filtra SQL, stack traces o datos sensibles.

El mecanismo de resultados, excepciones o errores debe seguir las convenciones
del proyecto activo.

## Composición e inyección de dependencias

El **composition root** es el lugar donde se crean y conectan las
implementaciones concretas:

```text
Configuración de arranque
  ├── crea el adaptador de persistencia
  ├── lo conecta al puerto de salida
  ├── crea el caso de uso
  └── conecta el adaptador de entrada al puerto de entrada
```

La inyección de dependencias es una técnica para construir objetos. No es
sinónimo de arquitectura hexagonal ni requiere obligatoriamente un contenedor.

## Transacciones, eventos y asíncronía

La arquitectura no impone una estrategia única:

- El límite transaccional debe estar coordinado sin acoplar el dominio a una API concreta.
- Los eventos de dominio expresan hechos relevantes internos.
- Los eventos de integración son contratos externos y pueden requerir traducción.
- La publicación de mensajes debe tener un puerto adecuado.
- Si persistencia y publicación deben ser atómicas, diseña explícitamente la consistencia; Transactional Outbox es una opción, no una consecuencia automática.
- Usa operaciones asíncronas cuando el stack y la frontera de I/O lo permitan.

## Organización del código

No existe una estructura única. Puede organizarse por capas, por módulos o
por funcionalidad:

```text
src/
  domain/
  application/
    ports/in/
    ports/out/
    use-cases/
  adapters/
    in/
    out/
  bootstrap/
```

Organizar por funcionalidad suele mantener juntos los contratos, casos de uso
y pruebas relacionadas. La estructura elegida debe hacer verificable la
dirección de dependencias.

## Pruebas

- **Dominio:** entidades, value objects, invariantes y servicios sin infraestructura.
- **Casos de uso:** orquestación con fakes, stubs o mocks de puertos de salida.
- **Adaptadores:** traducción de modelos, protocolos y errores.
- **Integración:** interacción entre piezas reales, como persistencia, mensajería o HTTP.
- **End-to-end:** comportamiento del sistema completo cuando aporte valor.

Una estrategia equilibrada prioriza pruebas rápidas del dominio y aplicación
y reserva las pruebas de integración para fronteras tecnológicas relevantes.

## Errores habituales

1. Hacer que el dominio dependa del ORM.
2. Ejecutar SQL en casos de uso.
3. Poner la lógica de negocio en controllers.
4. Definir puertos con tipos de infraestructura.
5. Crear interfaces sin una frontera útil.
6. Confundir puertos con adaptadores.
7. Duplicar reglas de negocio en varios adaptadores.
8. Abstraer tecnologías antes de tener una necesidad real.
9. Ignorar transacciones, consistencia o fallos externos.
10. Confundir el flujo de llamadas con la dirección de dependencias.

## Checklist

- [ ] ¿Están identificadas las reglas de negocio que deben protegerse?
- [ ] ¿Los casos de uso tienen responsabilidades claras?
- [ ] ¿Los puertos de entrada representan capacidades que pueden solicitarse?
- [ ] ¿Los puertos de salida expresan capacidades necesarias sin tipos externos?
- [ ] ¿Los adaptadores traducen modelos y protocolos en las fronteras?
- [ ] ¿El dominio puede probarse sin framework ni infraestructura?
- [ ] ¿Los casos de uso pueden probarse con dobles de sus puertos?
- [ ] ¿Los adaptadores de entrada son finos?
- [ ] ¿La composición de dependencias está localizada?
- [ ] ¿Validación, errores y transacciones están ubicados conscientemente?
- [ ] ¿Se han considerado seguridad, compatibilidad y datos sensibles?
- [ ] ¿Las abstracciones aportan independencia real?

## Prueba mental

Si se sustituye la base de datos, la interfaz de entrada o un proveedor
externo, ¿el dominio y los casos de uso pueden seguir funcionando sin cambios
importantes? Si la respuesta es sí, los límites probablemente están bien
planteados.

## Referencias

- Alistair Cockburn, [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/).
- Martin Fowler, [Inversion of Control Containers and the Dependency Injection pattern](https://martinfowler.com/articles/injection.html).
