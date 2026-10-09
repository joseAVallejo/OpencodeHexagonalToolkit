# OpencodeHexagonalToolkit

Toolkit reutilizable de OpenCode para proyectos que utilizan arquitectura
hexagonal, Clean Architecture y, cuando aplica, CQRS.

Incluye instrucciones, agentes, comandos y skills para ayudar a analizar,
planificar, implementar y revisar cambios manteniendo la separación entre
dominio, aplicación, infraestructura y delivery.

## Que incluye

- Arquitectura hexagonal y dirección de dependencias.
- Agentes para arquitectura, coordinación, planificación, implementación y revisión.
- Flujo Spec-Driven Development (SDD) con aprobaciones explícitas.
- Skills de arquitectura, seguridad y testing.
- Comandos `/architecture`, `/feature`, `/review` y `/sdd`.
- Documentación de principios y permisos.
- Instaladores remotos para Windows, macOS y Linux.

## Instalación rápida

Ejecuta el instalador desde la raíz del proyecto destino.

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/joseAVallejo/OpencodeHexagonalToolkit/main/scripts/Install.ps1 | iex
```

### macOS y Linux

```bash
curl -fsSL https://raw.githubusercontent.com/joseAVallejo/OpencodeHexagonalToolkit/main/scripts/Install.sh | sh
```

El instalador copia:

```text
AGENTS.md
docs/
.opencode/
```

No copia dependencias locales, configuraciones globales, credenciales ni
archivos de GitHub Actions.

## Conflictos

Por defecto, la instalación se detiene si alguno de los archivos ya existe.
Para sobrescribirlos explícitamente, descarga el script y ejecútalo con
`-Force` en PowerShell o `--force` en macOS/Linux.

### Windows con sobrescritura

```powershell
$installer = Join-Path $env:TEMP 'Install-OpenCode.ps1'
irm https://raw.githubusercontent.com/joseAVallejo/OpencodeHexagonalToolkit/main/scripts/Install.ps1 -OutFile $installer
& $installer -TargetPath (Get-Location).Path -Force
```

### macOS/Linux con sobrescritura

```bash
installer="$(mktemp)"
curl -fsSL https://raw.githubusercontent.com/joseAVallejo/OpencodeHexagonalToolkit/main/scripts/Install.sh -o "$installer"
sh "$installer" --force
rm -f "$installer"
```

## Estructura

```text
.
├── AGENTS.md
├── docs/
│   ├── Constitution.md
│   └── architecture/
└── .opencode/
    ├── agents/
    ├── commands/
    ├── plugins/
    └── skills/
```

La configuración de proveedores y modelos de `~/.config/opencode` no forma
parte de este toolkit y no se modifica durante la instalación.

## Uso en OpenCode

Después de instalar, reinicia OpenCode para cargar los cambios.

- `/architecture`: analiza capas, puertos, adaptadores y dependencias.
- `/feature`: implementa cambios pequeños sin el flujo SDD completo.
- `/review`: revisa una implementación contra requisitos, arquitectura y tests.
- `/sdd`: inicia el flujo de especificación, plan, tareas e implementación.

Para cambios relevantes, el flujo SDD requiere aprobar primero `specs.md` y,
posteriormente, `plan.md` junto con `tasks.md`.

## Compatibilidad

- Windows con PowerShell.
- macOS y Linux con `curl`, `tar` y un shell POSIX.
- El toolkit no impone un framework concreto; las instrucciones se adaptan a
  las convenciones del repositorio activo.

## Licencia

Añade la licencia que corresponda al publicar o distribuir este toolkit.
