[CmdletBinding()]
param(
    [string]$TargetPath = (Get-Location).Path,
    [switch]$Force,
    [string]$Repository = 'joseAVallejo/OpencodeHexagonalToolkit',
    [string]$Ref = 'main'
)

$ErrorActionPreference = 'Stop'

function Get-InstallFiles {
    return @(
        'AGENTS.md',
        'docs',
        '.opencode',
        'templates'
    )
}

function Get-RelativeFiles([string]$Root, [string[]]$Entries) {
    $files = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Entries) {
        $path = Join-Path $Root $entry
        if (-not (Test-Path -LiteralPath $path)) {
            throw "El archivo o directorio requerido no existe: $entry"
        }

        if ((Get-Item -LiteralPath $path).PSIsContainer) {
            Get-ChildItem -LiteralPath $path -File -Recurse | ForEach-Object {
                $files.Add($_.FullName.Substring($Root.Length + 1))
            }
        }
        else {
            $files.Add($path.Substring($Root.Length + 1))
        }
    }
    return $files
}

$target = [System.IO.Path]::GetFullPath($TargetPath)
New-Item -ItemType Directory -Force -Path $target | Out-Null

$temp = Join-Path ([System.IO.Path]::GetTempPath()) ("opencode-toolkit-" + [guid]::NewGuid().ToString('N'))
$archive = Join-Path $temp 'toolkit.zip'
$extract = Join-Path $temp 'extract'
$archiveUri = "https://github.com/$Repository/archive/refs/heads/$Ref.zip"

try {
    New-Item -ItemType Directory -Force -Path $extract | Out-Null
    Write-Host "Descargando $Repository ($Ref)..."
    Invoke-WebRequest -Uri $archiveUri -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $extract -Force

    $source = Get-ChildItem -LiteralPath $extract -Directory | Select-Object -First 1
    if ($null -eq $source) {
        throw 'No se encontró el contenido del repositorio descargado.'
    }

    $entries = Get-InstallFiles
    $sourceFiles = Get-RelativeFiles -Root $source.FullName -Entries $entries
    $conflicts = @($sourceFiles | Where-Object { Test-Path -LiteralPath (Join-Path $target $_) })

    if ($conflicts.Count -gt 0 -and -not $Force) {
        Write-Host 'Se conservarán los archivos existentes en el destino:' -ForegroundColor Yellow
        $conflicts | ForEach-Object { Write-Host "  $_" }
        Write-Host 'Usa -Force para sobrescribirlos explícitamente.' -ForegroundColor Yellow
    }

    foreach ($relativeFile in $sourceFiles) {
        $targetFile = Join-Path $target $relativeFile
        if ((Test-Path -LiteralPath $targetFile) -and -not $Force) {
            continue
        }

        $targetDirectory = Split-Path -Parent $targetFile
        New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
        Copy-Item -LiteralPath (Join-Path $source.FullName $relativeFile) -Destination $targetFile -Force
    }

    Write-Host "OpenCode Toolkit instalado en $target" -ForegroundColor Green
    Write-Host 'Reinicia OpenCode para cargar los agentes, comandos y skills.'
}
finally {
    if (Test-Path -LiteralPath $temp) {
        Remove-Item -LiteralPath $temp -Recurse -Force
    }
}
