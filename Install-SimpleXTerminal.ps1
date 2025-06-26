# Install-SimpleXTerminal.ps1

# Prompt user to confirm OpenSSL installation
$answer = Read-Host "Have you downloaded and installed OpenSSL 3.x (Win64) to the default folder (C:\Program Files\OpenSSL-Win64)? [y/N]"

if ($answer -ne 'y' -and $answer -ne 'Y') {
    Write-Host "Please download and install OpenSSL 3.x (Win64) from: https://slproweb.com/products/Win32OpenSSL.html"
    exit 1
}

# Create target directory if it doesn't exist
$targetDir = "$env:APPDATA\local\bin"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir | Out-Null
}

# Copy SimpleX binary (assumes it's in Downloads)
$simplexSrc = "$HOME\Downloads\simplex-chat-windows-x86-64"
$simplexDst = "$targetDir\simplex-chat.exe"
if (Test-Path $simplexSrc) {
    Copy-Item $simplexSrc $simplexDst -Force
    Write-Host "Copied simplex-chat binary to $simplexDst"
}
else {
    Write-Host "SimpleX binary not found in Downloads. Please download it and rerun this script."
    exit 1
}

# Copy required DLLs from OpenSSL
$opensslBin = "C:\Program Files\OpenSSL-Win64\bin"
$libcrypto = Join-Path $opensslBin "libcrypto-3-x64.dll"
$libssl = Join-Path $opensslBin "libssl-3-x64.dll"

if ((Test-Path $libcrypto) -and (Test-Path $libssl)) {
    Copy-Item $libcrypto $targetDir -Force
    Copy-Item $libssl $targetDir -Force
    Write-Host "Copied required DLLs to $targetDir"
}
else {
    Write-Host "Required DLLs not found in $opensslBin. Please check your OpenSSL installation."
    exit 1
}

# Add targetDir to user PATH if not already present
$userPath = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
if (-not $userPath.Split(';') -contains $targetDir) {
    $newPath = "$userPath;$targetDir"
    [System.Environment]::SetEnvironmentVariable('PATH', $newPath, 'User')
    Write-Host "$targetDir added to user PATH. You may need to restart your terminal."
}
else {
    Write-Host "$targetDir is already in your PATH."
}

Write-Host "SimpleX Chat terminal installation complete! You can now run 'simplex-chat.exe' from any terminal window."
