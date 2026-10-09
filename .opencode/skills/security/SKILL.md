---
name: security
description: Revisa autenticación, autorización, cifrado y documentación de permisos en funcionalidades.
---

# Security

Activa esta skill cuando una petición afecte autenticación, autorización,
políticas, permisos, cifrado o endpoints protegidos.

- Conserva los controles y comportamientos existentes.
- Registra cada cambio de permiso en `docs/architecture/permissions.md`.
- Comprueba cliente, adaptador de entrada, policy y constantes del proyecto cuando existan.
- No introduzcas secretos ni credenciales.
- Mantén la lógica de autorización en la capa o mecanismo que corresponda, no en controladores por comodidad.
