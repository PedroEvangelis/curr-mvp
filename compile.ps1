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

# --- Determine typst binary (cross-platform) ---
$isWin = $IsWindows -or (-not $PSVersionTable.PSEdition) -or ($env:OS -and $env:OS -match "Windows")
$typst = if ($isWin) { "bin/typst.exe" } else { "bin/typst" }
if (-not (Test-Path $typst)) {
    $typst = if ($isWin) { "bin/typst" } else { "bin/typst.exe" }
    if (-not (Test-Path $typst)) {
        Write-Error "Typst binary not found in bin/. Run ./setup.ps1 first."
        exit 1
    }
}
$typst = (Resolve-Path $typst).Path

# --- Resolve paths ---
$jsonFull = (Resolve-Path $JsonFile).Path
$pdfFull = if ($PdfFile) {
    if ([System.IO.Path]::IsPathRooted($PdfFile)) { $PdfFile }
    else { Join-Path (Get-Location) $PdfFile }
} else {
    [System.IO.Path]::ChangeExtension($jsonFull, ".pdf")
}

# --- Ensure output directory exists ---
$pdfDir = Split-Path $pdfFull -Parent
if (-not (Test-Path $pdfDir)) { New-Item -ItemType Directory -Path $pdfDir -Force | Out-Null }

# --- Use temp files with simple names to dodge quoting issues ---
$projectRoot = (Get-Location).Path
$tempJson = Join-Path $projectRoot "_temp_resume.json"
$tempPdf  = Join-Path $projectRoot "_temp_resume.pdf"

try {
    Copy-Item -Force $jsonFull $tempJson

    Write-Host "Compiling..."
    Write-Host "  JSON: $jsonFull"
    Write-Host "  PDF:  $pdfFull"

    # Path from templates/resume.typ to root-level _temp_resume.json: ../_temp_resume.json
    & $typst compile --root $projectRoot "templates/resume.typ" $tempPdf "--input" "data=../_temp_resume.json"

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
    # Safety: clean up stray temp PDF if move succeeded but something else failed
    if (Test-Path $tempPdf) { Remove-Item -Force $tempPdf }
}
