# Hexagonal Architecture

## Dependency Direction

```text
Domain <- Application <- Infrastructure adapters
                       <- Delivery adapters
```

The domain contains business concepts and rules. Application contains use
cases and coordinates ports. Infrastructure adapters implement outbound ports
for persistence and external services. Delivery adapters implement inbound
ports for HTTP, messaging, CLI or other protocols.

Dependencies point inward. The application must not depend on a concrete
database, transport or external service implementation.

## Ports and Adapters

- Inbound ports expose application use cases to delivery adapters.
- Outbound ports describe capabilities required by application or domain code.
- Adapters translate between external models and internal models.
- Mapping and validation belong at the appropriate boundary.
- Domain entities should not be used as external API contracts.

## Feature Organization

```text
Application/
└── Users/
    ├── Commands/
    │   └── CreateUser/
    │       ├── CreateUserCommand
    │       ├── CreateUserHandler
    │       └── CreateUserValidator
    └── Queries/
        └── GetUserById/
            ├── GetUserByIdQuery
            └── GetUserByIdHandler
```

Use the active repository's naming and framework conventions. CQRS, result
types, validation libraries and mapping tools are implementation choices, not
universal requirements.

## Feature Workflow

1. Identify the business rule and domain changes.
2. Define application use cases and ports.
3. Implement outbound and inbound adapters.
4. Add tests for the behavior-owning layer and adapter boundaries.
5. Verify compatibility, security and deployment concerns.
