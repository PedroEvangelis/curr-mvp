#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Compiles a resume JSON to PDF using the Typst template.
.DESCRIPTION
    Takes a canonical JSON from output/ and produces the final PDF.
    Cross-platform: works on Windows, Linux, and macOS (PowerShell 5.1+ / pwsh).
.PARAMETER JsonFile
    Path to the JSON file (required). Example: output/2026-06-02 x Empresa x Vaga.json
.PARAMETER PdfFile
    Output PDF path (optional). Defaults to same path as JSON with .pdf extension.
.EXAMPLE
    ./compile.ps1 "output/2026-06-02 x Empresa x Vaga.json"
.EXAMPLE
    ./compile.ps1 -JsonFile "resume.json" -PdfFile "curriculo.pdf"
#>
param(
    [Parameter(Mandatory, Position = 0)]
    [string]$JsonFile,

    [Parameter(Position = 1)]
    [string]$PdfFile
)

$projectRoot = Resolve-Path "$PSScriptRoot/../.."

# --- Determine typst binary (cross-platform) ---
$isWin = $IsWindows -or (-not $PSVersionTable.PSEdition) -or ($env:OS -and $env:OS -match "Windows")
$typstBin = if ($isWin) { "typst.exe" } else { "typst" }
$typst = Join-Path (Join-Path $projectRoot "bin") $typstBin
if (-not (Test-Path $typst)) {
    $altBin = if ($isWin) { "typst" } else { "typst.exe" }
    $alt = Join-Path (Join-Path $projectRoot "bin") $altBin
    if (-not (Test-Path $alt)) {
        Write-Error "Typst binary not found in bin/. Run ./setup.ps1 first."
        exit 1
    }
    $typst = $alt
}

# --- Lint and validate ---
Write-Host "Linting JSONs..."
bun run src/scripts/lint-json.ts
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# --- Resolve paths ---
$jsonFull = if ([System.IO.Path]::IsPathRooted($JsonFile)) { $JsonFile } else { Join-Path $projectRoot $JsonFile }
if (-not (Test-Path $jsonFull)) {
    Write-Error "JSON file not found: $jsonFull"
    exit 1
}

Write-Host "Validating schema..."
bun run src/scripts/validate-json.ts "$jsonFull"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$pdfFull = if ($PdfFile) {
    if ([System.IO.Path]::IsPathRooted($PdfFile)) { $PdfFile }
    else { Join-Path $projectRoot $PdfFile }
} else {
    [System.IO.Path]::ChangeExtension($jsonFull, ".pdf")
}

# --- Ensure output directory exists ---
$pdfDir = Split-Path $pdfFull -Parent
if (-not (Test-Path $pdfDir)) { New-Item -ItemType Directory -Path $pdfDir -Force | Out-Null }

# --- Use temp files with simple names to dodge quoting issues ---
$tempJson = Join-Path $projectRoot "_temp_resume.json"
$tempPdf  = Join-Path $projectRoot "_temp_resume.pdf"

try {
    Copy-Item -Force $jsonFull $tempJson

    Write-Host "Compiling..."
    Write-Host "  JSON: $jsonFull"
    Write-Host "  PDF:  $pdfFull"

    # Path from src/templates/resume.typ to root-level _temp_resume.json: ../../_temp_resume.json
    & $typst compile --root $projectRoot (Join-Path $projectRoot "src/templates/resume.typ") $tempPdf "--input" "data=../../_temp_resume.json"

    if ($LASTEXITCODE -eq 0) {
        Move-Item -Force $tempPdf $pdfFull
        Write-Host "  ✅ PDF: $pdfFull"
    } else {
        Write-Host "  ❌ Compilation failed (exit code: $LASTEXITCODE)"
        if (Test-Path $tempPdf) { Remove-Item -Force $tempPdf }
        exit $LASTEXITCODE
    }
} finally {
    if (Test-Path $tempJson) { Remove-Item -Force $tempJson }
    if (Test-Path $tempPdf) { Remove-Item -Force $tempPdf }
}
