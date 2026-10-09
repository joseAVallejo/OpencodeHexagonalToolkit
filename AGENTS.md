# Project Agent Instructions

## Scope

These instructions apply to projects using hexagonal or Clean Architecture
with CQRS. Inspect the active repository before assuming project names,
frameworks, layers or build commands.

## Architecture

- Keep the domain isolated from infrastructure and delivery mechanisms.
- Keep application use cases independent from external adapters.
- Define ports as interfaces at the boundary that owns the abstraction.
- Keep adapters and I/O in infrastructure or delivery layers.
- Organize code by feature instead of isolated technical type folders.
- Do not expose domain entities directly through external contracts.
- Keep business rules out of controllers, endpoints and infrastructure code.

The generic architecture reference is `docs/architecture/hexagonal.md`.

## Operational Rules

- Follow patterns already present in the active repository.
- Validate inputs at the application boundary.
- Represent predictable business failures using the project's established result or error pattern.
- Preserve existing authentication, authorization, encryption and compatibility behavior.
- Do not introduce secrets, credentials or sensitive data.
- Update `docs/architecture/permissions.md` when permissions change.

## Verification

Discover and use the repository's documented build, test and publish commands.
Run focused tests first, then the relevant full validation command.

## Local Extensions

Use `/extension` to create project-specific skills, agents or commands. Keep
those extensions in the active project and read `docs/extending.md` before
creating them. Do not assume a local extension belongs in the shared toolkit.

## Spec-Driven Development

New features and significant functional changes follow `.opencode/skills/sdd/SKILL.md`.
Do not implement before explicit approval of `specs.md`, followed by joint
approval of `plan.md` and `tasks.md`. Preserve history under
`docs/specs/NNN_<feature>/`.

## References

- Principles: `docs/Constitution.md`
- Architecture: `docs/architecture/hexagonal.md`
- Permissions: `docs/architecture/permissions.md`
- Skills: `.opencode/skills/`
- Agents: `.opencode/agents/`
