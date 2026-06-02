param(
    [string]$Version = "v0.14.2"
)

$ErrorActionPreference = "Stop"

# --- Detect platform ---
$arch = "x86_64"
$procArch = $env:PROCESSOR_ARCHITECTURE
if ($procArch -match "ARM") { $arch = "aarch64" }

if ($env:OS -match "Windows") {
    $os = "pc-windows-msvc"
    $ext = "zip"
    $binary = "typst.exe"
} else {
    $uname = uname -s
    $unameArch = uname -m
    if ($unameArch -eq "arm64" -or $unameArch -eq "aarch64") { $arch = "aarch64" }
    if ($uname -eq "Darwin") {
        $os = "apple-darwin"
    } elseif ($uname -eq "Linux") {
        $os = "unknown-linux-musl"
    } else {
        Write-Error "Unsupported OS: $uname"
        exit 1
    }
    $ext = "tar.xz"
    $binary = "typst"
}

$file = "typst-$arch-$os.$ext"
$url = "https://github.com/typst/typst/releases/download/$Version/$file"

# --- Prepare directories ---
$outDir = Join-Path $PSScriptRoot "bin"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$tempDir = Join-Path $env:TEMP "typst-setup"
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# --- Download ---
Write-Host "Downloading Typst $Version ($arch-$os)..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile (Join-Path $tempDir $file) -UseBasicParsing

# --- Extract ---
Write-Host "Extracting..." -ForegroundColor Cyan
if ($ext -eq "zip") {
    Expand-Archive -Path (Join-Path $tempDir $file) -DestinationPath $tempDir -Force
    $found = Get-ChildItem -Path $tempDir -Recurse -Filter $binary
    if ($found.Count -gt 0) {
        Move-Item -Path $found[0].FullName -Destination (Join-Path $outDir $binary) -Force
    }
} else {
    tar -xf (Join-Path $tempDir $file) -C $tempDir
    $found = Get-ChildItem -Path $tempDir -Recurse -Filter $binary -File
    if ($found.Count -gt 0) {
        Move-Item -Path $found[0].FullName -Destination (Join-Path $outDir $binary) -Force
    }
}

# --- Cleanup ---
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# --- Verify ---
$installed = Join-Path $outDir $binary
if (Test-Path $installed) {
    Write-Host "Typst installed to $installed" -ForegroundColor Green
    & $installed --version
} else {
    Write-Error "Binary not found after extraction"
    exit 1
}
