#!/usr/bin/env sh
set -eu

REPOSITORY="joseAVallejo/OpencodeHexagonalToolkit"
REF="main"
TARGET_PATH="$(pwd)"
FORCE=0

usage() {
    printf '%s\n' \
        'Uso: Install.sh [--target RUTA] [--force] [--repository OWNER/REPO] [--ref RAMA]' \
        '' \
        'Instala AGENTS.md, docs/ y .opencode/ en el proyecto destino.'
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --target|-t)
            [ "$#" -ge 2 ] || { printf '%s\n' 'Falta la ruta de --target.' >&2; exit 2; }
            TARGET_PATH="$2"
            shift 2
            ;;
        --repository)
            [ "$#" -ge 2 ] || { printf '%s\n' 'Falta el valor de --repository.' >&2; exit 2; }
            REPOSITORY="$2"
            shift 2
            ;;
        --ref)
            [ "$#" -ge 2 ] || { printf '%s\n' 'Falta el valor de --ref.' >&2; exit 2; }
            REF="$2"
            shift 2
            ;;
        --force)
            FORCE=1
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            printf 'Argumento no reconocido: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

command -v curl >/dev/null 2>&1 || { printf '%s\n' 'Se requiere curl.' >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { printf '%s\n' 'Se requiere tar.' >&2; exit 1; }

TARGET_PATH="$(cd "$TARGET_PATH" 2>/dev/null && pwd || true)"
[ -n "$TARGET_PATH" ] || { printf '%s\n' 'La ruta destino no existe.' >&2; exit 1; }

TEMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t opencode-toolkit)"
ARCHIVE="$TEMP_DIR/toolkit.tar.gz"
EXTRACT="$TEMP_DIR/extract"
ARCHIVE_URL="https://github.com/$REPOSITORY/archive/refs/heads/$REF.tar.gz"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT INT TERM

mkdir -p "$EXTRACT"
printf 'Descargando %s (%s)...\n' "$REPOSITORY" "$REF"
curl -fsSL "$ARCHIVE_URL" -o "$ARCHIVE"
tar -xzf "$ARCHIVE" -C "$EXTRACT"

SOURCE_DIR="$(find "$EXTRACT" -mindepth 1 -maxdepth 1 -type d -print -quit)"
[ -n "$SOURCE_DIR" ] || { printf '%s\n' 'No se encontró el contenido descargado.' >&2; exit 1; }

FILES="$(find "$SOURCE_DIR/AGENTS.md" "$SOURCE_DIR/docs" "$SOURCE_DIR/.opencode" -type f -print | sed "s#^$SOURCE_DIR/##")"
CONFLICTS=""
while IFS= read -r file; do
    [ -n "$file" ] || continue
    if [ -e "$TARGET_PATH/$file" ]; then
        CONFLICTS="$CONFLICTS$file\n"
    fi
done <<EOF
$FILES
EOF

if [ -n "$CONFLICTS" ] && [ "$FORCE" -ne 1 ]; then
    printf '%s\n' 'Se conservarán los archivos existentes en el destino:'
    printf '%b' "$CONFLICTS"
    printf '%s\n' 'Usa --force para sobrescribirlos explícitamente.' >&2
fi

while IFS= read -r file; do
    [ -n "$file" ] || continue
    target_file="$TARGET_PATH/$file"
    if [ -e "$target_file" ] && [ "$FORCE" -ne 1 ]; then
        continue
    fi

    mkdir -p "$(dirname "$target_file")"
    cp "$SOURCE_DIR/$file" "$target_file"
done <<EOF
$FILES
EOF

printf 'OpenCode Toolkit instalado en %s\n' "$TARGET_PATH"
