# Project Constitution

> Technical and collaboration principles for projects using hexagonal or Clean Architecture.

## 1. Architecture and Dependencies

1. The domain must not depend on infrastructure, delivery mechanisms or external frameworks unless the repository explicitly requires it.
2. Application code owns use cases and depends on domain abstractions.
3. Infrastructure implements ports and integrates databases, services and frameworks.
4. Delivery layers translate external protocols into application requests and responses.
5. Dependencies point inward; inner layers must not depend on outer layers.
6. Organize code by feature and follow existing repository conventions.

## 2. Application Patterns

- Separate commands and queries when CQRS is used.
- Validate inputs at the application boundary.
- Use the repository's established result and error model for predictable failures.
- Do not expose domain entities directly in external contracts.
- Keep business logic in domain/application layers, not in controllers or adapters.
- Use asynchronous I/O where supported by the technology stack.

## 3. Security and Compatibility

- Preserve existing authentication, authorization and encryption behavior.
- Document permission changes in `docs/architecture/permissions.md`.
- Do not include secrets, credentials or sensitive data.
- Consider API contracts, persisted data, integrations and configuration before changing behavior.

## 4. Quality and Validation

- Define verifiable acceptance criteria before implementing significant behavior.
- Add or update tests in the layer that owns the behavior.
- Do not declare work complete while mandatory criteria or validation remain unresolved.
- Prefer focused validation followed by the repository's complete test suite.

## 5. Spec-Driven Development

- Significant functional changes follow the SDD skill in `.opencode/skills/sdd/SKILL.md`.
- Approved specifications are the source of truth for requirements and acceptance criteria.
- Plans and tasks must derive from the approved specification.
- Preserve `specs.md`, `plan.md` and `tasks.md` with their change history.

## 6. Conflicts

If a specification, plan or instruction conflicts with this Constitution or
the active repository, stop the affected decision, identify the discrepancy
and ask for clarification. Do not silently resolve conflicts by assumption.
